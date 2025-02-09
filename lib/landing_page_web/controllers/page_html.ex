defmodule LandingPageWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use LandingPageWeb, :html
  import LandingPageWeb.Components.Navbar


  embed_templates "page_html/*"
end
