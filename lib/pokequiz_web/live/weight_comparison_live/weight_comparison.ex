defmodule PokequizWeb.WeightComparisonLive.Show do
  # In a typical Phoenix app, the following line would usually be `use MyAppWeb, :live_view`
  use PokequizWeb, :live_component

  alias Pokequiz.Dex
  import Pokequiz.Session.Helper
  
  import PokequizWeb.CoreComponents
     
  def display_name(), do: "Who is heavier?"
  def value_handle(), do: "weight_comparison"
   

  def handle_event("new", _, socket) do
    %{assigns: %{quiz: quiz, name: name}} = socket
    pokemans = Dex.Pokemon.two_equal()
    quiz =
      quiz
      |> Map.put(:pokemon_1, Dex.Pokemon.weight_calc(Enum.at(pokemans, 0), :weight))
      |> Map.put(:pokemon_2, Dex.Pokemon.weight_calc(Enum.at(pokemans, 1), :weight))
      |> Map.put(:opacity, "opacity-0")
      |> Map.put(:finished, false)
      |> Map.put(:won, false)

    :ok = GenServer.cast(via_tuple(name), {:update_quiz, quiz})
    :ok = Phoenix.PubSub.broadcast(Pokequiz.PubSub, name, :update)
    
    {:noreply, socket}
  end


  def handle_event("pokemon_1", _, socket) do
    %{assigns: %{quiz: %{pokemon_1: pokemon_1, pokemon_2: pokemon_2}, name: name, player: player}} = socket
    %{assigns: %{quiz: quiz}} = socket

    if !quiz.finished do
      won = pokemon_1.weight >= pokemon_2.weight

      quiz =
        quiz
        |> Map.put(:opacity, "opacity-100")
        |> Map.put(:finished, true)
        |> Map.put(:won, won)
    
      :ok = GenServer.cast(via_tuple(name), {:update_quiz, quiz})
      :ok = Phoenix.PubSub.broadcast(Pokequiz.PubSub, name, :update)

      player = if won do Pokequiz.Player.increase_score(player) else player end

      :ok = GenServer.cast(via_tuple(name), {:change_player, player})
      :ok = Phoenix.PubSub.broadcast(Pokequiz.PubSub, name, :update)
    end
    
    {:noreply, socket}  
  end

  def handle_event("pokemon_2", _, socket) do  
    %{assigns: %{quiz: %{pokemon_1: pokemon_1, pokemon_2: pokemon_2}, name: name, player: player}} = socket
    %{assigns: %{quiz: quiz}} = socket

    if !quiz.finished do
      won = pokemon_2.weight >= pokemon_1.weight

      quiz =
        quiz
        |> Map.put(:opacity, "opacity-100")
        |> Map.put(:finished, true)
        |> Map.put(:won, won)
    
      :ok = GenServer.cast(via_tuple(name), {:update_quiz, quiz})
      :ok = Phoenix.PubSub.broadcast(Pokequiz.PubSub, name, :update)

      player = if won do Pokequiz.Player.increase_score(player) else player end

      :ok = GenServer.cast(via_tuple(name), {:change_player, player})
      :ok = Phoenix.PubSub.broadcast(Pokequiz.PubSub, name, :update)
    end
    
    {:noreply, socket}  
  end

  def startup() do
    pokemans = Dex.Pokemon.two_equal()

    %{}
    |> Map.put(:module, __MODULE__)
    |> Map.put(:pokemon_1, Dex.Pokemon.weight_calc(Enum.at(pokemans, 0), :weight))
    |> Map.put(:pokemon_2, Dex.Pokemon.weight_calc(Enum.at(pokemans, 1), :weight))
    |> Map.put(:opacity, "opacity-0")
    |> Map.put(:finished, false)
    |> Map.put(:won, false)
  end

end
