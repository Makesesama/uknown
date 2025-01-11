defmodule Pokequiz.Dex.Pokemon do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pokequiz.Repo

  alias __MODULE__
  alias Pokequiz.Dex

  import Ecto.Query, only: [from: 2]

  schema "pokemon_v2_pokemon" do
    field :name, :string
    field :order, :integer
    field :height, :integer
    field :weight, :float
    field :is_default, :boolean, default: false
    field :base_experience, :integer
    field :picked, :boolean, [virtual: true, default: false]
    
    many_to_many :types, Dex.Type, join_through: "pokemon_v2_pokemontype"

    belongs_to :species, Dex.Species, foreign_key: :pokemon_species_id

    many_to_many :moves, Dex.Move, join_through: "pokemon_v2_pokemonmove"
  end

                                                 @doc false
  def changeset(pokemon, attrs) do
    pokemon
    |> cast(attrs, [:name, :order, :height, :weight, :is_default, :base_experience])
    |> validate_required([:name, :order, :height, :weight, :is_default, :base_experience])
  end

  def image(pokemon) do
    "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/#{pokemon.id}.png"
  end

  def weight_calc(list, field) do
    Map.update!(list, field, fn weight -> weight /10 end)
  end

  def random() do
    Repo.all(Pokemon)
    |> Enum.random
    |> Repo.preload(:species)
    |> Repo.preload(species: :names)
  end

  def random(number) do
    Repo.all(Pokemon)
    |> Enum.take_random(number)
    |> Repo.preload(:species)
    |> Repo.preload(species: :names)
  end

  def two_equal() do

    first = Pokemon.random()
    max_weight = trunc(first.weight * 1.50)
    min_weight = trunc(first.weight * 0.50)

    query =
      from p in Pokemon,
           where: p.weight <= ^max_weight and p.id != ^first.id and p.weight >= ^min_weight and p.weight != ^first.weight,
           select: p

    results = Repo.all(query)
    
    Enum.shuffle([first, Enum.random(results)])

  end

end
