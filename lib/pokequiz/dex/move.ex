defmodule Pokequiz.Dex.Move do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__

  alias Pokequiz.Repo

  import Ecto.Query, only: [from: 2]

  schema "pokemon_v2_move" do
    field :name, :string
    field :power, :integer
    field :pp, :integer
    field :accuracy, :integer
    field :priority, :integer
    field :move_effect_chance, :integer

    many_to_many :pokemon, Pokequiz.Dex.Pokemon, join_through: "pokemon_v2_pokemonmove"
  end

  @doc false
  def changeset(pokemon, attrs) do
    pokemon
    |> cast(attrs, [:name, :power, :pp, :accuracy, :priority, :move_effect_chance])
    |> validate_required([:name, :power, :pp, :accuracy, :priority, :move_effect_chance])
  end

  def random() do
    Repo.all(Move)
    |> Enum.random()
    |> Repo.preload(:pokemon)
  end

  def pokemon(move_id) do
  end
end
