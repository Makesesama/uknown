defmodule Pokequiz.Quiz.Sessions do
  use Ecto.Schema
  import Ecto.Changeset

  schema "quiz_sessions" do
    field :players, :integer
    field :game_master, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(sessions, attrs) do
    sessions
    |> cast(attrs, [:players, :game_master])
    |> validate_required([:players, :game_master])
  end
end
