defmodule PokequizWeb.Games.PokemonForMoveLive.Show do
  # In a typical Phoenix app, the following line would usually be `use MyAppWeb, :live_view`
  use PokequizWeb, :live_component
  @behaviour Pokequiz.Game
  import Pokequiz.Session.Helper
  import PokequizWeb.CoreComponents

  alias Pokequiz.Dex

  def display_name(), do: gettext("Which Pokemon learn this Move?")
  def value_handle(), do: "pokemon_for_move"

  def handle_event("new", _, %{assigns: %{quiz: quiz, name: name}} = socket) do
    move = Dex.Move.random()

    pokemon =
      move.pokemon
      |> Enum.uniq()
      |> Pokequiz.Repo.preload(species: :names)

    quiz =
      quiz
      |> Map.put(:pokemon, pokemon)
      |> Map.put(:move, move)
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
        Enum.map(pokemon, fn x ->
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
        if picked <= Enum.count(pokemon, fn x -> x.picked end) do
          ["Not a correct Pokemon"]
        else
          []
        end

      finished = picked == Enum.count(new_pokemon)

      quiz =
        quiz
        |> Map.put(:pokemon, new_pokemon)
        |> Map.put(:finished, finished)
        |> Map.put(:pick, picked)
        |> Map.put(:won, false)

      game_end(name, quiz, player)

      socket =
        socket
        |> assign(input_error: error)
        |> assign(input_value: "")

      {:noreply, socket}
    end
  end

  def init(socket) do
    move = Dex.Move.random()

    pokemon =
      move.pokemon
      |> Enum.uniq()
      |> Pokequiz.Repo.preload(species: :names)

    %{}
    |> Map.put(:module, __MODULE__)
    |> Map.put(:pokemon, pokemon)
    |> Map.put(:move, move)
    |> Map.put(:pick, 0)
    |> Map.put(:finished, false)
    |> Map.put(:won, false)
  end
end
