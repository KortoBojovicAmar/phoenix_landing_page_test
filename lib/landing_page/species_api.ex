defmodule LandingPage.SpeciesAPI do
  @api_url "https://api.gbif.org/v1/species"

  def search_species(scientific_name) do
    url = "#{@api_url}/search?q=#{URI.encode(scientific_name)}"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)}

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Erreur HTTP: #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
