defmodule LandingPage.SpeciesAPI do
  @api_url "https://api.api-ninjas.com/v1/animals"
  @api_key "kdLqdPfZ5DJH76HajCSV3w==D23GMtSxpqIThEhH"

  def search_endangered_species(offset \\ 0, limit \\ 6) do
    # Liste de termes courants pour obtenir un maximum d'animaux
    search_terms = ["mammal", "bird", "reptile", "amphibian"]

    headers = [
      {"X-Api-Key", @api_key},
      {"Content-Type", "application/json"}
    ]

    # Récupérer les résultats pour chaque terme de recherche
    all_results = Enum.flat_map(search_terms, fn term ->
      url = "#{@api_url}?name=#{URI.encode(term)}"

      case HTTPoison.get(url, headers) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          Jason.decode!(body)
        _ ->
          []
      end
    end)

    # Filtrer pour ne garder que les espèces menacées
    threatened_species = Enum.filter(all_results, fn animal ->
      case get_in(animal, ["characteristics", "biggest_threat"]) do
        threat when is_binary(threat) and threat != "" -> true
        _ -> false
      end
    end)
    |> Enum.uniq_by(fn animal -> animal["name"] end)  # Éviter les doublons

    # Paginer les résultats
    paginated_results = threatened_species
      |> Enum.drop(offset)
      |> Enum.take(limit)

    {:ok, %{"results" => paginated_results, "count" => length(threatened_species)}}
  end

  def paginate_species(page \\ 1, limit \\ 6) do
    offset = (page - 1) * limit
    search_endangered_species(offset, limit)
  end
end
