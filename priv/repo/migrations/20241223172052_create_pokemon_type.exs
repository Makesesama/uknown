defmodule Pokequiz.Repo.Migrations.CreatePokemonType do
  use Ecto.Migration

  def change do
    create table(:pokemon_type) do
      add :name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
