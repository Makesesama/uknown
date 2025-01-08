defmodule Pokequiz.Dex.Pokemon do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pokequiz.Repo

  import Ecto.Query, only: [from: 2]

  schema "pokemon_v2_pokemon" do
    field :name, :string
    field :order, :integer
    field :height, :integer
    field :weight, :integer
    field :is_default, :boolean, default: false
    field :base_experience, :integer
    field :picked, :boolean, [virtual: true, default: false]
    
    many_to_many :types, Pokequiz.Dex.Type, join_through: "pokemon_v2_pokemontype"

    belongs_to :species, Pokequiz.Dex.Species, foreign_key: :pokemon_species_id
  end

                                                 @doc false
  def changeset(pokemon, attrs) do
    pokemon
    |> cast(attrs, [:name, :order, :height, :weight, :is_default, :base_experience])
    |> validate_required([:name, :order, :height, :weight, :is_default, :base_experience])
  end

  def random() do
    Repo.all(Pokequiz.Dex.Pokemon)
    |> Enum.random
    |> Repo.preload(:species)
    |> Repo.preload(species: :names)
  end

end
