defmodule Pokequiz.QuizFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pokequiz.Quiz` context.
  """

  @doc """
  Generate a session.
  """
  def session_fixture(attrs \\ %{}) do
    {:ok, session} =
      attrs
      |> Enum.into(%{
        game_master: true,
        players: 42,
        session_type: "some session_type"
      })
      |> Pokequiz.Quiz.create_session()

    session
  end

  @doc """
  Generate a sessions.
  """
  def sessions_fixture(attrs \\ %{}) do
    {:ok, sessions} =
      attrs
      |> Enum.into(%{
        game_master: true,
        players: 42
      })
      |> Pokequiz.Quiz.create_sessions()

    sessions
  end
end
