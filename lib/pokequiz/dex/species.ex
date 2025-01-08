defmodule Pokequiz.Dex.Species do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pokequiz.Repo

  import Ecto.Query, only: [from: 2]
  
  schema "pokemon_v2_pokemonspecies" do
    field :name, :string

    has_many :pokemon, Pokequiz.Dex.Pokemon, foreign_key: :pokemon_species_id
    has_many :names, Pokequiz.Dex.Name, foreign_key: :pokemon_species_id
  end

    @doc false
    def changeset(type, attrs) do
      type
      |> cast(attrs, [:name])
      |> validate_required([:name])
    end

end
