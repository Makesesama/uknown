defmodule Pokequiz.Dex.Language do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pokequiz.Repo

  import Ecto.Query, only: [from: 2]

  schema "pokemon_v2_language" do
    field :name, :string

    has_one :pokemon, Pokequiz.Dex.Name
  end

  @doc false
  def changeset(type, attrs) do
    type
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
