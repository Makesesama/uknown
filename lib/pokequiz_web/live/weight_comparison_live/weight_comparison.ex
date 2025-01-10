defmodule PokequizWeb.WeightComparisonLive.Show do
  # In a typical Phoenix app, the following line would usually be `use MyAppWeb, :live_view`
  use PokequizWeb, :live_view

  alias Pokequiz.Dex

  import PokequizWeb.CoreComponents
     

  def mount(params, session, socket) do
    #TODO Sometimes this gets a weird type Kombo like normal nil
    pokemans = Dex.Pokemon.two_equal()

    
    socket =
      socket
      |> assign(page_title: "Pokemon Weight Comparison?")
      |> assign(pokemon_1: Dex.Pokemon.weight_calc(Enum.at(pokemans, 0), :weight))
      |> assign(pokemon_2: Dex.Pokemon.weight_calc(Enum.at(pokemans, 1), :weight))
      |> assign(won: nil)
      |> assign(show_weight: false)
      |> assign(opacity: "opacity-0")

    {:ok, socket}
  end

  def handle_event("new", _, socket) do
    pokemans = Dex.Pokemon.two_equal()
    socket =
      socket
      |> assign(pokemon_1: Dex.Pokemon.weight_calc(Enum.at(pokemans, 0), :weight))
      |> assign(pokemon_2: Dex.Pokemon.weight_calc(Enum.at(pokemans, 1), :weight))
      |> assign(won: nil)
      |> assign(show_weight: false)
      |> assign(opacity: "opacity-0")

    {:noreply, socket}
  end


  def handle_event("pokemon_1", _, socket) do
    %{assigns: %{pokemon_1: pokemon_1}} = socket
    %{assigns: %{pokemon_2: pokemon_2}} = socket

    socket =
      socket
      |> assign(won: pokemon_1.weight >= pokemon_2.weight)
      |> assign(show_weight: true)
      |> assign(opacity: "opacity-100")
  
    {:noreply, socket}
end

def handle_event("pokemon_2", _, socket) do
  %{assigns: %{pokemon_1: pokemon_1}} = socket
  %{assigns: %{pokemon_2: pokemon_2}} = socket

  socket =
    socket
    |> assign(won: pokemon_2.weight >= pokemon_1.weight)
    |> assign(show_weight: true)
    |> assign(opacity: "opacity-100")
  
  {:noreply, socket}
end


end
