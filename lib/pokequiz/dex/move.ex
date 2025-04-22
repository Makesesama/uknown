defmodule Pokequiz.Dex.Move do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__
  alias Pokequiz.Dex

  alias Pokequiz.Repo

  import Ecto.Query, only: [from: 2]

  schema "pokemon_v2_move" do
    field :name, :string
    field :power, :integer
    field :pp, :integer
    field :accuracy, :integer
    field :priority, :integer
    field :move_effect_chance, :integer
    field :generation_id, :integer

    many_to_many :pokemon, Dex.Pokemon, join_through: "pokemon_v2_pokemonmove"
  end

  @doc false
  def changeset(pokemon, attrs) do
    pokemon
    |> cast(attrs, [:name, :power, :pp, :accuracy, :priority, :move_effect_chance])
    |> validate_required([:name, :power, :pp, :accuracy, :priority, :move_effect_chance])
  end

  def random(count \\ 1, generation_blacklist \\ 9) do
    query = from m in Move,
                 where: m.generation_id <= ^generation_blacklist,
                 limit: ^count,
                 order_by: fragment("RANDOM()")

    pokemon_query = from p in Dex.Pokemon,
                         join: s in Dex.Species,
                         on: p.pokemon_species_id == s.id,
                         where: s.generation_id <= ^generation_blacklist

    Repo.all(query)
    |> Repo.preload([pokemon: {pokemon_query, []}])
  end
end
