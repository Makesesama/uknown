defmodule Pokequiz.Dex.Pokemon do
  use Ecto.Schema
  import Ecto.Changeset
  use Gettext, backend: PokequizWeb.Gettext

  alias Pokequiz.Repo

  alias __MODULE__
  alias Pokequiz.Dex

  import Ecto.Query, only: [from: 2]

  @spriteless ["togedemaru-totem", "koraidon-gliding-build"]

  schema "pokemon_v2_pokemon" do
    field :name, :string
    field :order, :integer
    field :height, :integer
    field :weight, :float
    field :is_default, :boolean, default: false
    field :base_experience, :integer
    field :picked, :boolean, [virtual: true, default: false]
    field :has_sprite, :boolean, [virtual: true, default: true]
    
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

  defp get_language_base_name(pokemon) do
    case Gettext.get_locale(PokequizWeb.Gettext) do
      "de" -> Enum.at(pokemon.species.names, 5)
      "en" -> Enum.at(pokemon.species.names, 8)
      _ -> Enum.at(pokemon.species.names, 8)
    end
  end

  defp convert_name(pokemon) do
    base_name = get_language_base_name(pokemon)
    case String.split(pokemon.name, "-") do
      [ _ , "mega"] -> "#{gettext("mega")} #{base_name.name}"
      [ _ , "galar"] -> "#{gettext("galarian")} #{base_name.name}"
      [ _ , "hisui"] -> "#{gettext("hisui")} #{base_name.name}"
      [ _ , "gmax"] -> "#{gettext("gmax")} #{base_name.name}"
      _ -> base_name.name
    end
  end
  
  defp convert_to(%Pokemon{} = pokemon) do
    %{pokemon | name: convert_name(pokemon)}
  end

  defp convert_to(pokemon) do
    Enum.map(pokemon, fn x ->    %{x | name: convert_name(x)} end)
  end

  def weight_calc(list, field) do
    Map.update!(list, field, fn weight -> weight /10 end)
  end

  def get_by_name(name) do
    Repo.get_by(Pokemon, name: name)
    |> Repo.preload(species: :names)
    |> convert_to()
    |> add_is_spriteless()
  end

  def random(number \\ 1, generation_blacklist \\ []) do
    query =
      from poke in Pokemon,
           join: s in Dex.Species,
           on: poke.pokemon_species_id == s.id,
           limit: ^number,
           where: s.generation_id not in ^generation_blacklist,
           order_by: fragment("RANDOM()")
      
    pokemon =
      Repo.all(query)
      |> Repo.preload(species: :names)
      |> convert_to()
      |> add_is_spriteless()

    if number == 1 do Enum.at(pokemon, 0) else pokemon end
  end

  def two_equal(1, generation_blacklist \\ []) do
    first = Pokemon.random(1, generation_blacklist)
    max_weight = trunc(first.weight * 1.50)
    min_weight = trunc(first.weight * 0.50)

    query =
      from p in Pokemon,
           where: p.weight <= ^max_weight and p.id != ^first.id and p.weight >= ^min_weight and p.weight != ^first.weight,
           select: p,
           limit: 1

    results = Repo.one(query)
    
    Enum.shuffle([first, results])
  end

  defp add_is_spriteless(%Pokemon{} = pokemon) do
    if pokemon.name in @spriteless do
      %{pokemon | has_sprite: false}
    else
      pokemon
    end
  end

  defp add_is_spriteless(pokemon) do
    Enum.map(pokemon, fn x -> add_is_spriteless(x) end)
  end
  
end
