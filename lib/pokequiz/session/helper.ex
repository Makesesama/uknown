defmodule Pokequiz.Session.Helper do
  def via_tuple(name) do
    {:via, Registry, {Pokequiz.SessionRegistry, name}}
  end

  def notify_other(name, quiz) do
    :ok = GenServer.cast(via_tuple(name), {:update_quiz, quiz})
    :ok = Phoenix.PubSub.broadcast(Pokequiz.PubSub, name, :update)
  end
end
