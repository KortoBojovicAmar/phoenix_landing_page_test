defmodule LandingPageWeb.SpeciesLive do
  use Phoenix.LiveView
  alias LandingPage.SpeciesAPI

  def mount(_params, _session, socket) do
    case SpeciesAPI.paginate_species(1) do
      {:ok, response} ->
        IO.inspect(response, label: "API Response")
        {:ok, assign(socket, species: response["results"] || [], page: 1, error: nil)}
      {:error, reason} ->
        {:ok, assign(socket, species: [], page: 1, error: "Error: #{reason}")}
    end
  end

  def handle_event("next_page", _params, socket) do
    page = socket.assigns.page + 1
    case SpeciesAPI.paginate_species(page) do
      {:ok, %{"results" => results}} when results != [] ->
        {:noreply, assign(socket, species: results, page: page, error: nil)}
      {:ok, _} ->
        {:noreply, assign(socket, error: "Aucune espèce trouvée.")}
      {:error, reason} ->
        {:noreply, assign(socket, error: "Erreur : #{reason}")}
    end
  end

  def handle_event("prev_page", _params, socket) do
    page = max(socket.assigns.page - 1, 1)
    case SpeciesAPI.paginate_species(page) do
      {:ok, %{"results" => results}} when results != [] ->
        {:noreply, assign(socket, species: results, page: page, error: nil)}
      {:ok, _} ->
        {:noreply, assign(socket, error: "Aucune espèce trouvée.")}
      {:error, reason} ->
        {:noreply, assign(socket, error: "Erreur : #{reason}")}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="flex justify-center">
      <div class="max-w-5xl">
        <header>
          <LandingPageWeb.Components.Navbar.navbar id="" variant="default" >
            <:start_content>
              <.link
                navigate="/"
                class="flex items-center space-x-3 rtl:space-x-reverse mb-5 md:mb-0"
              >
                <img src="/images/logo.png" alt="le logo d'APP"/>
                <p class="pb-3 text-2xl font-bold text-green_logo_contrast">
                  APP
                </p>
              </.link>
            </:start_content>
            <:list><.link title="aide" navigate="/">Aide</.link></:list>

            <:list><.link title="blog" navigate="/">Blog</.link></:list>

            <:list><.link title="animaux" navigate="/">Retour à l'accueil</.link></:list>

            <!--
            <:list><p>installer l'app<.link title="installation link" navigate="/pppp"><svg src="/assets/static/images/android_button.svg"></svg></.link></p></:list>
              -->
          </LandingPageWeb.Components.Navbar.navbar>
        </header>
        <main>
        <section class="px-12 py-20 bg-green_primary">
          <h1 class="p-8 text-center text-3xl font-bold">Voici les espèces que vous pouvez aider en nous rejoignant.</h1>
          <p class="text-center text-lg font-medium">
            App s'engage sur la protection des espèces menacées.
            En rejoignant notre application, vous participez à la protection de ces animaux.
          </p>
        </section>
          <%= if @species == [] do %>
            <p class="text-gray-600">Aucune espèce menacée trouvée</p>
          <% end %>
        <section class="container mx-auto p-8  bg-grey_light pt-20">
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            <%= for animal <- @species do %>
            <div class="card bg-grey_light shadow-xl rounded-lg overflow-hidden">
                <div class="p-0 bg-grey_primary">
                  <h2 class="text-xl font-bold bg-green_secondary p-3 rounded-lg-t"><%= animal["name"] %></h2>
                  <LandingPageWeb.Components.Card.card_media class="w-full" src="/images/chimere_etrusque.jpg" alt="image de l'animal"/>
                  <LandingPageWeb.Components.Card.card_content class="p-4 space-y-2 pt-3 bg-grey_light">
                    <p class="text-black font-semibold"><span class="font-bold">Habitat :</span> <%= animal["characteristics"]["habitat"] %></p>
                    <p class="text-black font-semibold"><span class="font-bold">Régime :</span> <%= animal["characteristics"]["diet"] %></p>
                    <p class="text-black font-semibold"><span class="font-bold">Menace principale :</span> <%= animal["characteristics"]["biggest_threat"] %></p>
                    <p class="text-black font-semibold"><span class="font-bold">Localisation :</span> <%= Enum.join(animal["locations"], ", ") %></p>
                  </LandingPageWeb.Components.Card.card_content>
                </div>
              </div>
            <% end %>
          </div>
          <div class="flex justify-center pt-10 pb-20">
            <div class="mt-4 space-x-2">
              <button phx-click="prev_page" disabled={@page == 1} class="px-4 py-2 bg-green_button text-grey_light rounded disabled:opacity-50">
                Précédent
              </button>
              <span class="px-4 py-2 text-black">
                Page <%= @page %>
              </span>
              <button phx-click="next_page" class="px-4 py-2 bg-green_button text-grey_light rounded">
                Suivant
              </button>
            </div>
          </div>
        </section>
        </main>
        <LandingPageWeb.Components.Footer.footer class="bg-green_primary py-20" variant="bordered" font_weight="font-bold" text_position="center">tout droit reservé - App&#169; - 2025</LandingPageWeb.Components.Footer.footer>
      </div>
    </div>
    """
  end
end
