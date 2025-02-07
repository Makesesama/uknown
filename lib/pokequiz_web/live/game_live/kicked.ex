defmodule PokequizWeb.GameLive.Lobby.Kicked do
  use PokequizWeb, :live_view

  import PokequizWeb.CoreComponents

  def mount(_params, session, socket) do
    # We need to assign the value from the cookie in mount
    {:ok, socket}
  end
end
