defmodule Pokequiz.Dex.Name do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pokequiz.Repo

  import Ecto.Query, only: [from: 2]

  schema "pokemon_v2_pokemonspeciesname" do
    field :name, :string
    field :genus, :string

    belongs_to :pokemon, Pokequiz.Dex.Species, foreign_key: :pokemon_species_id
    belongs_to :language, Pokequiz.Dex.Language
  end

  @doc false
  def changeset(type, attrs) do
    type
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def get_like(search) do
    query =
      from p in Pokequiz.Dex.Name,
        where: like(p.name, ^"%#{search}%"),
        where: p.language_id in [6, 9]

    Repo.all(query)
  end
end
