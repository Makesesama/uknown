defmodule PokequizWeb.Games.TypeCombinationLive.Show do
  # In a typical Phoenix app, the following line would usually be `use MyAppWeb, :live_view`
  use PokequizWeb, :live_component

  @behaviour Pokequiz.Game

  import Pokequiz.Session.Helper
  import PokequizWeb.CoreComponents

  alias Pokequiz.Dex

  def display_name(), do: gettext("Which Pokemon have these types?")
  def value_handle(), do: "type_combination"

  def handle_event("new", _, %{assigns: %{quiz: quiz, name: name}} = socket) do
    types = Dex.Type.random_kombo_with_pokemon(Pokequiz.Session.Settings.generations_to_blacklist(socket.assigns.settings.generations))

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

    if quiz.finished do
      {:noreply, socket}
    else
      new_pokemon =
        Enum.map(pokemon.pokemon, fn x ->
          cond do
            String.downcase(x.name) == String.downcase(msg) ->
              %{x | picked: true}

            String.downcase(Enum.at(x.species.names, 5).name) == String.downcase(msg) ->
              %{x | picked: true}

            true ->
              x
          end
        end)

      picked = Enum.count(new_pokemon, fn x -> x.picked end)

      error =
        if picked <= Enum.count(pokemon.pokemon, fn x -> x.picked end) do
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
        |> Map.put(:won, finished)

      game_end(name, quiz, player)

      socket =
        socket
        |> assign(:input_error, error)
        |> assign(:input_value, "")

      {:noreply, socket}
    end
  end

  def init(socket) do
    types = Dex.Type.random_kombo_with_pokemon(Pokequiz.Session.Settings.generations_to_blacklist(socket.assigns.game.settings.generations))

    %{}
    |> Map.put(:module, __MODULE__)
    |> Map.put(:pokemon, types)
    |> Map.put(:pick, 0)
    |> Map.put(:finished, false)
    |> Map.put(:won, false)
  end
end
