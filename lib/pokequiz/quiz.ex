defmodule Pokequiz.Quiz do
  @moduledoc """
  The Quiz context.
  """

  import Ecto.Query, warn: false
  alias Pokequiz.Repo

  alias Pokequiz.Quiz.Sessions

  @doc """
  Returns the list of quiz_sessions.

  ## Examples

      iex> list_quiz_sessions()
      [%Sessions{}, ...]

  """
  def list_quiz_sessions do
    Repo.all(Sessions)
  end

  @doc """
  Gets a single sessions.

  Raises `Ecto.NoResultsError` if the Sessions does not exist.

  ## Examples

      iex> get_sessions!(123)
      %Sessions{}

      iex> get_sessions!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sessions!(id), do: Repo.get!(Sessions, id)

  @doc """
  Creates a sessions.

  ## Examples

      iex> create_sessions(%{field: value})
      {:ok, %Sessions{}}

      iex> create_sessions(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sessions(attrs \\ %{}) do
    %Sessions{}
    |> Sessions.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a sessions.

  ## Examples

      iex> update_sessions(sessions, %{field: new_value})
      {:ok, %Sessions{}}

      iex> update_sessions(sessions, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sessions(%Sessions{} = sessions, attrs) do
    sessions
    |> Sessions.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a sessions.

  ## Examples

      iex> delete_sessions(sessions)
      {:ok, %Sessions{}}

      iex> delete_sessions(sessions)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sessions(%Sessions{} = sessions) do
    Repo.delete(sessions)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sessions changes.

  ## Examples

      iex> change_sessions(sessions)
      %Ecto.Changeset{data: %Sessions{}}

  """
  def change_sessions(%Sessions{} = sessions, attrs \\ %{}) do
    Sessions.changeset(sessions, attrs)
  end
end
