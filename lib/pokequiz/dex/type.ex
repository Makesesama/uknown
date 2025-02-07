defmodule Pokequiz.Dex.Type do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pokequiz.Repo

  alias __MODULE__
  alias Pokequiz.Dex.Pokemon

  import Ecto.Query, only: [from: 2]

  schema "pokemon_v2_type" do
    field :name, :string

    many_to_many :pokemon, Pokemon, join_through: "pokemon_v2_pokemontype"
  end

  @doc false
  def changeset(type, attrs) do
    type
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  defp two_random_types() do
    Repo.all(Pokemon)
    |> Repo.preload(:types)
    |> Enum.filter(fn x -> Enum.count(x.types) > 1 end)
    |> Enum.random()
    |> Map.get(:types)
  end

  def random() do
    Repo.all(Type)
    |> Enum.random()
  end

  def get_random_kombo() do
    types = two_random_types()

    first_type_pokemon =
      hd(types)
      |> Repo.preload(:pokemon)
      |> Map.get(:pokemon)
      |> Repo.preload(:types)
      |> Repo.preload(:species)
      |> Repo.preload(species: :names)

    types_string =
      types
      |> Enum.map(fn x -> x.name end)

    pokemon =
      first_type_pokemon
      |> Enum.filter(fn x -> Enum.member?(x.types, hd(Enum.reverse(types))) end)

    %{pokemon: pokemon, types: types_string}
  end
end
