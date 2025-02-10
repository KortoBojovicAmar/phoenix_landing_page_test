# defmodule LandingPageWeb.PageLive do
#   use LandingPageWeb, :live_view
defmodule LandingPageWeb.PageComponent do
  use Phoenix.LiveComponent
  import LandingPageWeb.Router.Helpers, only: [sigil_p: 2]

  @api_url "https://api.gbif.org/v1/species"

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page, 1)}
  end

  def handle_params(params, _uri, socket) do
    page = params["page"] || 1
    data = fetch_data(page)
    {:noreply, assign(socket, data: data, page: page)}
  end

  defp fetch_data(page) do
    url = "#{@api_url}?page=#{page}"
    {:ok, response} = HTTPoison.get(url)
    {:ok, %{"results" => results}} = Jason.decode(response.body)
    results
  end

  def render(assigns) do
    ~H"""
    <section class="px-12 py-10">
      <h2 class="pt-8 pb-4 text-center text-3xl font-bold">Liste des cartes</h2>
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
        <%= for item <- @data do %>
          <div class="card bg-white shadow-md rounded-lg p-6">
            <h3 class="text-xl font-bold"><%= item["title"] %></h3>
            <p class="text-lg"><%= item["description"] %></p>
          </div>
        <% end %>
      </div>
      <div class="flex justify-center mt-6">
        <%= if @page > 1 do %>
          <.link navigate={~p"/?page=#{@page - 1}"} class="btn btn-primary">Précédent</.link>
        <% end %>
        <.link navigate={~p"/?page=#{@page + 1}"} class="btn btn-primary ml-4">Suivant</.link>
      </div>
    </section>
    """
  end
end
