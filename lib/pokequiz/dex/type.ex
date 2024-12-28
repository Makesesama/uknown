defmodule Pokequiz.Dex.Type do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pokequiz.Repo

  import Ecto.Query, only: [from: 2]
  
  schema "pokemon_v2_type" do
    field :name, :string

    many_to_many :pokemon, Pokequiz.Dex.Pokemon, join_through: "pokemon_v2_pokemontype"
  end

  @doc false
  def changeset(type, attrs) do
    type
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def get_random_kombo() do
    types =
      Repo.all(Pokequiz.Dex.Pokemon)
      |> Repo.preload(:types)
      |> Enum.filter(fn x -> x.types > 1 end)
      |> Enum.random()
      |> Map.get(:types)


    first_type_pokemon =
      hd(types)
      |> Repo.preload(:pokemon)
      |> Map.get(:pokemon)
      |> Repo.preload(:types)

    types_string =
      types
      |> Enum.map(fn x -> x.name end)

    pokemon =
      first_type_pokemon
      |> Enum.filter(fn x -> Enum.member?(x.types, hd Enum.reverse(types)) end)

    %{pokemon: pokemon, types: types_string}
  end
end
