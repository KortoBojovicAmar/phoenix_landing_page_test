defmodule LandingPage.Users do
use Ecto.Schema
import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :password_hash, :string
    field :age, :integer

    timestamps()

  end
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :age])
    |> validate_required([:email])
    |> unique_constraint(:email)
  end
end
