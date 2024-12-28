defmodule Pokequiz.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions) do
      add :players, :integer
      add :session_type, :string
      add :game_master, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
