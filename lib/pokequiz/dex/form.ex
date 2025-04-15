defmodule Pokequiz.Dex.Pokemon.Form do
  use Ecto.Schema
  import Ecto.Changeset
  use Gettext, backend: PokequizWeb.Gettext

  alias Pokequiz.Repo

  alias __MODULE__
  alias Pokequiz.Dex

  import Ecto.Query, only: [from: 2]

  schema "pokemon_v2_pokemonform" do
    field :name, :string
    field :form_name, :string
    field :is_mega, :boolean

    belongs_to :pokemon, Dex.Pokemon, foreign_key: :pokemon_id
  end

    @doc false
    def changeset(pokemon, attrs) do
      pokemon
      |> cast(attrs, [:name, :order, :height, :weight, :is_default, :base_experience])
      |> validate_required([:name, :order, :height, :weight, :is_default, :base_experience])
    end
end
