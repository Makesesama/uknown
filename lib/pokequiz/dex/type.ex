defmodule Pokequiz.Dex.Type do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pokequiz.Repo

  alias __MODULE__
  alias Pokequiz.Dex

  import Ecto.Query, only: [from: 2]

  schema "pokemon_v2_type" do
    field :name, :string
    field :generation_id, :integer

    many_to_many :pokemon, Pokemon, join_through: "pokemon_v2_pokemontype"
  end

  @doc false
  def changeset(type, attrs) do
    type
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def random(count \\ 1, generation_blacklist \\ 9) do
    query =
      from type in Type,
           limit: ^count,
           where: type.generation_id <= ^generation_blacklist,
           order_by: fragment("RANDOM()")
    
    Repo.all(query)
  end

  def load_pokemon(types, generation_blacklist \\ 9) do
    pokemon_query =
      from p in Dex.Pokemon,
           join: s in Dex.Species,
           on: p.pokemon_species_id == s.id,
           join: t in assoc(p, :types),
           where: t.name in ^types,
           where: s.generation_id <= ^generation_blacklist,
           group_by: [p.id, s.id],
           having: fragment("COUNT(DISTINCT ?) = ?", t.name, ^length(types)),
           preload: [:types, species: :names]

    Repo.all(pokemon_query)
  end

  defp combinations(list, 2) do
    for i <- 0..(length(list) - 2),
        j <- (i + 1)..(length(list) - 1),
        do: [Enum.at(list, i), Enum.at(list, j)]
  end

  def random_kombo_with_pokemon(generation_blacklist \\ 9) do
    # Step 1: Get all dual-typed Pokémon with generation filter
    pokemon_with_types_query =
      from p in Dex.Pokemon,
           join: s in Dex.Species, on: p.pokemon_species_id == s.id,
           join: t in assoc(p, :types),
           where: s.generation_id <= ^generation_blacklist,
           select: {p.id, t.name}

    # Step 2: Group types by Pokémon
    type_pairs =
      Repo.all(pokemon_with_types_query)
      |> Enum.group_by(fn {pokemon_id, _type} -> pokemon_id end, fn {_, type} -> type end)
      |> Enum.filter(fn {_id, types} -> length(types) >= 2 end)
      |> Enum.flat_map(fn {_id, types} ->
        types
        |> Enum.uniq()
        |> combinations(2)
        |> Enum.map(&Enum.sort/1)
      end)
      |> Enum.uniq()

    case type_pairs do
      [] ->
        %{types: [], pokemon: []}

      _ ->
        chosen_types = Enum.random(type_pairs)
        pokemon = load_pokemon(chosen_types, generation_blacklist)
        %{types: chosen_types, pokemon: pokemon}
    end
  end
end
