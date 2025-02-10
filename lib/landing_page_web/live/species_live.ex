defmodule LandingPageWeb.SpeciesLive do
  use Phoenix.LiveView
  alias LandingPage.SpeciesAPI

  def mount(_params, _session, socket) do
    {:ok, assign(socket, species: nil, query: "", error: nil)}
  end

  def handle_event("search", %{"query" => query}, socket) do
    case SpeciesAPI.search_species(query) do
      {:ok, %{"results" => results}} when length(results) > 0 ->
        {:noreply, assign(socket, species: hd(results), error: nil)}

      {:ok, _} ->
        {:noreply, assign(socket, species: nil, error: "Aucune espèce trouvée.")}

      {:error, reason} ->
        {:noreply, assign(socket, species: nil, error: "Erreur : #{reason}")}
    end
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Recherche d'espèces</h1>
      <form phx-submit="search">
        <input type="text" name="query" value={@query} placeholder="Nom scientifique" />
        <button type="submit">Rechercher</button>
      </form>
      <LandingPageWeb.Components.Button.button variant="default" class="mt-10 bg-black text-green_primary"><a href="/">Retour à l'accueil</a></LandingPageWeb.Components.Button.button>

      <%= if @error do %>
        <p style="color: red;"><%= @error %></p>
      <% end %>

      <%= if @species do %>
        <h2>Résultats pour : <%= @species["scientificName"] %></h2>
        <p>Rang : <%= @species["rank"] %></p>
        <p>Royaume : <%= @species["kingdom"] %></p>
        <p>Phylum : <%= @species["phylum"] %></p>
        <p>Classe : <%= @species["class"] %></p>
        <p>Ordre : <%= @species["order"] %></p>
        <p>Famille : <%= @species["family"] %></p>
        <p>Genre : <%= @species["genus"] %></p>
      <% end %>
    </div>
    """
  end
end
