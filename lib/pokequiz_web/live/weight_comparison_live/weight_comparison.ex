defmodule PokequizWeb.WeightComparisonLive.Show do
  # In a typical Phoenix app, the following line would usually be `use MyAppWeb, :live_view`
  use Phoenix.LiveView

  import PokequizWeb.CoreComponents
     

  def mount(params, session, socket) do
    #TODO Sometimes this gets a weird type Kombo like normal nil

    pokemon_1 = Pokequiz.Dex.Pokemon.random()
    pokemon_2 = Pokequiz.Dex.Pokemon.random()
    
    socket =
      socket
      |> assign(page_title: "Pokemon Weight Comparison?")
      |> assign(pokemon_1: pokemon_1)
      |> assign(pokemon_2: pokemon_2)
      |> assign(won: nil)
      |> assign(show_weight: false)
      |> assign(opacity: "opacity-0")

    {:ok, socket}
  end

  def handle_event("new", _, socket) do
    socket =
      socket
      |> assign(pokemon_1: Pokequiz.Dex.Pokemon.random())
      |> assign(pokemon_2: Pokequiz.Dex.Pokemon.random())
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
      |> assign(won: pokemon_1.weight > pokemon_2.weight)
      |> assign(show_weight: true)
      |> assign(opacity: "opacity-100")
  
    {:noreply, socket}
end

def handle_event("pokemon_2", _, socket) do
  %{assigns: %{pokemon_1: pokemon_1}} = socket
  %{assigns: %{pokemon_2: pokemon_2}} = socket

  socket =
    socket
    |> assign(won: pokemon_2.weight > pokemon_1.weight)
    |> assign(show_weight: true)
    |> assign(opacity: "opacity-100")
  
  {:noreply, socket}
end


end
