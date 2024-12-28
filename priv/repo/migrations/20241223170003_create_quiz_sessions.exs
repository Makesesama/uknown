defmodule Pokequiz.Repo.Migrations.CreateQuizSessions do
  use Ecto.Migration

  def change do
    create table(:quiz_sessions) do
      add :players, :integer
      add :game_master, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
