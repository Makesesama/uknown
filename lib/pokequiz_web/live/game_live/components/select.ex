defmodule PokequizWeb.GameLive.Lobby.SelectComponent do
  use PokequizWeb, :live_component


  def render(assigns) do
    ~H"""
    <div class="">
      <button class="inline-flex flex items-center text-sm bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 max-w-24 rounded" value="whois" phx-click="select_quiz">Who Is</button>
      <button class="inline-flex flex items-center text-sm bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 max-w-24 rounded" value="weight_comparison" phx-click="select_quiz">Who is Heavier</button>
      <button class="inline-flex flex items-center text-sm bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 max-w-24 rounded" value="pokemon_for_move" phx-click="select_quiz">Who can learn that Move</button>
      <button class="inline-flex flex items-center text-sm bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 max-w-24 rounded" value="type_combination" phx-click="select_quiz">Type Compination Quiz</button>
    </div>
    """
  end
  
end
