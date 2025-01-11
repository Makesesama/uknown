defmodule PokequizWeb.WhoisLive.Show do
  # In a typical Phoenix app, the following line would usually be `use MyAppWeb, :live_view`
  use PokequizWeb, :live_component

  import Pokequiz.Session.Helper
  import PokequizWeb.CoreComponents

  alias Pokequiz.Dex

  def display_name(), do: "Who is that Pokemon?"
  def value_handle(), do: "whois"

  def handle_event("new", _, socket) do
    %{assigns: %{quiz: quiz, name: name}} = socket
    quiz =
      quiz
      |> Map.put(:pokemon, Dex.Pokemon.random())
      |> Map.put(:pick, ["absolute", "top-8", "left-[8%]", "filter", "brightness-0"])
      |> Map.put(:finished, false)
    
    :ok = GenServer.cast(via_tuple(name), {:update_quiz, quiz})
    :ok = Phoenix.PubSub.broadcast(Pokequiz.PubSub, name, :update)
    
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
      picked =
        cond do
          String.downcase(pokemon.name) == String.downcase(msg) ->
            ["absolute", "transition", "duration-1000", "top-8", "left-[8%]", "filter"]
          String.downcase(Enum.at(pokemon.species.names, 5).name) == String.downcase(msg) ->
            ["absolute", "transition", "duration-1000", "top-8", "left-[8%]", "filter"]
          true ->
            ["absolute", "transition", "duration-1000", "top-8", "left-[8%]", "filter", "brightness-0"]
        end
        
      finished = String.downcase(pokemon.name) == String.downcase(msg) or  String.downcase(Enum.at(pokemon.species.names, 5).name) == String.downcase(msg)

      quiz =
        quiz
        |> Map.put(:pick, picked)
        |> Map.put(:finished, finished)
    
      :ok = GenServer.cast(via_tuple(name), {:update_quiz, quiz})
      :ok = Phoenix.PubSub.broadcast(Pokequiz.PubSub, name, :update)

      player = if finished do Pokequiz.Player.increase_score(player) else player end

      :ok = GenServer.cast(via_tuple(name), {:change_player, player})
      :ok = Phoenix.PubSub.broadcast(Pokequiz.PubSub, name, :update)
    
      {:noreply, assign(socket, input_value: "")}
    else
      {:noreply, socket}
    end
  end

  def startup() do
    pokemon = Dex.Pokemon.random()
    IO.inspect(pokemon)
    %{}
    |> Map.put(:module, __MODULE__)
    |> Map.put(:pokemon, pokemon)
    |> Map.put(:pick, ["absolute", "transition", "duration-1000", "top-8", "left-[8%]", "filter", "brightness-0"])
    |> Map.put(:finished, false)
  end

end
