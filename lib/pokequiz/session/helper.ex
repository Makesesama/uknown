defmodule Pokequiz.Session.Helper do
  def via_tuple(name) do
    {:via, Registry, {Pokequiz.SessionRegistry, name}}
  end

  def push_quiz(name, quiz) do
    :ok = GenServer.cast(via_tuple(name), {:update_quiz, quiz})
    :ok = Phoenix.PubSub.broadcast(Pokequiz.PubSub, name, :update)
    name
  end

  def push_player(name, player) do
    :ok = GenServer.cast(via_tuple(name), {:change_player, player})
    :ok = Phoenix.PubSub.broadcast(Pokequiz.PubSub, name, :update)
    name
  end

  def game_end(name, quiz, player) do
    player = if quiz.won do Pokequiz.Player.increase_score(player) else player end

    push_quiz(name, quiz)
    |> push_player(player)
  end

  def game_end?(name, quiz, player) do
    if quiz.finished do game_end(name, quiz, player) end
  end
  
end
