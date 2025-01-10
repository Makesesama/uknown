defmodule PokequizWeb.GameLive.Lobby.SelectComponent do
  use PokequizWeb, :live_component


  def render(assigns) do
    ~H"""
    <div class="">
      <button class="inline-flex flex items-center text-sm bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 max-w-24 rounded" value="whois" phx-click="select_quiz">Who Is</button>
    </div>
    """
  end
  
end
