defmodule PokequizWeb.GameLive.PlayerComponent do
  use PokequizWeb, :live_component

  use Gettext, backend: PokequizWeb.Gettext

  def render(assigns) do
    ~H"""
    <div class="grid border border-2 rounded rounded-lg max-w-sm p-6">
      <h5 class="text-xl font-bold tracking-right">{@player.name}</h5>

      <%= case @player.ready do %>
        <% false -> %>
          {gettext("Not Ready")}
        <% true -> %>
          {gettext("Ready")}
      <% end %>

      <button
        class="inline-flex flex items-center text-sm bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 max-w-24 rounded"
        value={@player.name}
        phx-click="remove_player"
      >
        {gettext("Remove")}
      </button>
    </div>
    """
  end
end
