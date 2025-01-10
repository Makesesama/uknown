defmodule PokequizWeb.GameLive.PlayerComponent do
  use PokequizWeb, :live_component


  def render(assigns) do
    ~H"""
    <div class="grid border border-2 rounded rounded-lg max-w-sm p-6">
      <h5 class="text-xl font-bold tracking-right">{@player.name}</h5>

      <%= case @player.ready do %>
      <% false -> %>
      Not Ready
      <% true -> %>
      Ready
      <% end %>
      
      <button class="inline-flex flex items-center text-sm bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 max-w-24 rounded" value={@player.name} phx-click="remove_player">Remove</button>
    </div>
    """
  end
  
end
