defmodule Pokequiz.Player do

  alias __MODULE__

  defstruct [:name, :session_cookie, score: 0, ready: false, vote: false]

  def restore_from_cookie(players, cookie) do
    Enum.find(players, fn x -> x.session_cookie == cookie end)
  end

  def restore_from_name(players, name) do
    Enum.find(players, fn x -> x.name == name end)
  end

  def all_ready(players) do
    all_players =
      players
      |> Enum.map(fn x -> x.ready end)
      |> Enum.all?()

    all_players and Enum.count(players) > 0
  end

  def increase_score(players, player) do
    players
    |> Enum.map(fn x ->
      if x.name == player.name do
        increase_score(x)
      else
        x
      end
    end)
  end

  def increase_score(player = %Player{score: score}) do
    IO.inspect(score)
    Map.put(player, :score, score + 1)
  end
  
end
