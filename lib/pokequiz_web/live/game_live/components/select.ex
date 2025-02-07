defmodule PokequizWeb.GameLive.Lobby.SelectComponent do
  use PokequizWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="flex flex-col min-h-screen justify-center items-center">
      <h1 class="font-bold text-xl">Pick a game:</h1>
      <div class="flex flex-col gap-2">
        <button
          class="flex items-center text-sm bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded justify-center"
          value="whois"
          phx-click="select_quiz"
        >
          <p>Who Is</p>
        </button>
        <button
          class="inline-flex flex items-center text-sm bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded justify-center"
          value="weight_comparison"
          phx-click="select_quiz"
        >
          Who is Heavier
        </button>
        <button
          class="inline-flex flex items-center text-sm bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded justify-center"
          value="pokemon_for_move"
          phx-click="select_quiz"
        >
          Who can learn that Move
        </button>
        <button
          class="inline-flex flex items-center text-sm bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded justify-center"
          value="type_combination"
          phx-click="select_quiz"
        >
          Type Compination Quiz
        </button>
      </div>
    </div>
    """
  end
end
