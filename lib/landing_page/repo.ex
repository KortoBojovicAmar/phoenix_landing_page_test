defmodule LandingPage.Repo do
  use Ecto.Repo,
    otp_app: :landing_page,
    adapter: Ecto.Adapters.Postgres
end
