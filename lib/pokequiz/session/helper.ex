defmodule Pokequiz.Session.Helper do
  def via_tuple(name) do
    {:via, Registry, {Pokequiz.SessionRegistry, name}}
  end
end
