defmodule Pokequiz.Player do

  alias __MODULE__

  defstruct [:name, :session_cookie, score: 0, ready: false, vote: false]

  def restore_from_cookie(players, cookie) do
    Enum.find(players, fn x -> x.session_cookie == cookie end)
  end

  def restore_from_name(players, name) do
    get_from_list(players, name)
  end

  def all_ready(players) do
    # Enum.reduce(players, %{ready: true}, fn x, acc -> x.ready && acc.ready end)
    !Enum.any?(players, fn player -> player.ready == false end)
  end

  def all_vote(players) do
    !Enum.any?(players, fn player -> player.vote == false end)
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
    Map.put(player, :score, score + 1)
  end

  def get_from_list(players, name) do
    Enum.find(players, fn player -> player.name == name end)
  end

  def update_in_list(players, player) do
    Enum.map(players, fn x ->
      if x.name == player.name do
        player
      else
        x
      end
    end)
  end

  def remove_from_list(players, name) do
    Enum.filter(players, fn x -> x.name != name end)
  end
end
