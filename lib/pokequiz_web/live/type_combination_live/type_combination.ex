defmodule PokequizWeb.TypeCombinationLive.Show do
  # In a typical Phoenix app, the following line would usually be `use MyAppWeb, :live_view`
  use PokequizWeb, :live_component

  import Pokequiz.Session.Helper
  import PokequizWeb.CoreComponents
  
  alias Pokequiz.Dex

  def display_name(), do:  "Which Pokemon have these types?"
  def value_handle(), do: "type_combination"
  
  def startup() do
    types = Dex.Type.get_random_kombo()

    %{}
    |> Map.put(:module, __MODULE__)
    |> Map.put(:pokemon, types)
    |> Map.put(:pick, 0)
    |> Map.put(:finished, false)
  end

  def handle_event("new", _, %{assigns: %{quiz: quiz, name: name}} = socket) do
    types = Dex.Type.get_random_kombo()

    quiz =
      quiz
      |> Map.put(:pokemon, types)
      |> Map.put(:pick, 0)
      |> Map.put(:finished, false)

    push_quiz(name, quiz)
    
    {:noreply, socket}
  end

  def handle_event("completion", %{"input_value" => msg}, socket) do
    list = Dex.Name.get_like(msg)
    {:noreply, assign(socket, datalist: list)}
  end


  def handle_event("submit", %{"input_value" => msg}, socket) do
    %{assigns: %{quiz: %{pokemon: pokemon}, name: name, player: player}} = socket
    %{assigns: %{quiz: quiz}} = socket
    
    if !quiz.finished do
      new_pokemon = Enum.map(pokemon.pokemon, fn x ->
        cond do
          String.downcase(x.name) == String.downcase(msg) ->
            %{x | picked: true}
          String.downcase(Enum.at(x.species.names, 5).name) == String.downcase(msg) ->
            %{x | picked: true}
          true ->
            x
        end
      end)

      picked = Enum.count(Enum.filter(new_pokemon, fn x -> x.picked end))
     
      error = if picked <= Enum.count(Enum.filter(pokemon.pokemon, fn x -> x.picked end)) do
                ["Not a correct Pokemon"]
             else
               []
      end

      finished = picked == Enum.count(new_pokemon)

      quiz =
        quiz
        |> Map.put(:pokemon, %{pokemon: new_pokemon, types: pokemon.types})
        |> Map.put(:finished, finished)
        |> Map.put(:pick, picked)

      push_quiz(name, quiz)

      player = if error == [] do Pokequiz.Player.increase_score(player) else player end

      push_player(name, player)
      
      socket =
        socket
        |> assign(:input_error, error)
        |> assign(:input_value, "")
    
      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

end
