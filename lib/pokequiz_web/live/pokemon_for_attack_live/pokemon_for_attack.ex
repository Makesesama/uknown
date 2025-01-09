defmodule PokequizWeb.PokemonForAttackLive.Show do
  # In a typical Phoenix app, the following line would usually be `use MyAppWeb, :live_view`
  use PokequizWeb, :live_view

  import PokequizWeb.CoreComponents

  alias Pokequiz.Dex

  def mount(params, session, socket) do
    move =Dex.Move.random()
    IO.inspect(move)
      
    socket =
      socket
      |> assign(page_title: "Pokemon Type Combination Quiz")
      |> assign(move: move)


    {:ok, socket}
  end

  
  def handle_event("new", _, socket) do
    types = Dex.Type.get_random_kombo()
    IO.inspect(types)
    socket =
      socket
      |> assign(pokemon: types)
      |> assign(pick: 0)
      |> assign(input_value: "")

    {:noreply, socket}
  end

  def handle_event("completion", %{"input_value" => msg}, socket) do
    list = Dex.Name.get_like(msg)
  
    {:noreply, assign(socket, datalist: list)}
  end

  def handle_event("submit", %{"input_value" => msg}, socket) do
    %{assigns: %{pokemon: pokemon}} = socket

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

     
    color = if Enum.count(Enum.filter(new_pokemon, fn x -> x.picked end)) <= Enum.count(Enum.filter(pokemon.pokemon, fn x -> x.picked end)) do
              ["Not a correct Pokemon"]
            else
              []
    end
        
    
    socket =
      socket
      |> assign(:pokemon, %{pokemon: new_pokemon, types: pokemon.types})
      |> assign(:pick, Enum.count(Enum.filter(new_pokemon, fn x -> x.picked end)))
      |> assign(:input_color, color)
      |> assign(:input_value, "")
    
    {:noreply, socket}
  end

end
