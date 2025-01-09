defmodule PokequizWeb.WhoisLive.Show do
  # In a typical Phoenix app, the following line would usually be `use MyAppWeb, :live_view`
  use Phoenix.LiveView

  import PokequizWeb.CoreComponents
     

  def mount(params, session, socket) do
    #TODO Sometimes this gets a weird type Kombo like normal nil

    pokemon = Pokequiz.Dex.Pokemon.random()
    IO.inspect(pokemon)
    socket =
      socket
      |> assign(page_title: "Pokemon Who Is?")
      |> assign(pokemon: pokemon)
      |> assign(input_error: [])
      |> assign(datalist: [])
      |> assign(pick: ["absolute", "transition", "duration-1000", "top-8", "left-[8%]", "filter", "brightness-0"])
      |> assign(:won, false)

    {:ok, socket}
  end

  def handle_event("new", _, socket) do
    socket =
      socket
      |> assign(pokemon: Pokequiz.Dex.Pokemon.random())
      |> assign(pick: ["absolute", "top-8", "left-[8%]", "filter", "brightness-0"])
      |> assign(:won, false)

    {:noreply, socket}
  end

  def handle_event("completion", %{"input_value" => msg}, socket) do
    list = Pokequiz.Dex.Name.get_like(msg)
  
    {:noreply, assign(socket, datalist: list)}
  end

  def handle_event("submit", %{"input_value" => msg}, socket) do
    %{assigns: %{pokemon: pokemon}} = socket

    picked =
      cond do
        String.downcase(pokemon.name) == String.downcase(msg) ->
          ["absolute", "transition", "duration-1000", "top-8", "left-[8%]", "filter"]
        String.downcase(Enum.at(pokemon.species.names, 5).name) == String.downcase(msg) ->
          ["absolute", "transition", "duration-1000", "top-8", "left-[8%]", "filter"]
        true ->
          ["absolute", "transition", "duration-1000", "top-8", "left-[8%]", "filter", "brightness-0"]
      end
        
    won = String.downcase(pokemon.name) == String.downcase(msg) or  String.downcase(Enum.at(pokemon.species.names, 5).name) == String.downcase(msg)
    
    socket =
      socket
      |> assign(:pick, picked)
      |> assign(:input_value, "")
      |> assign(:won, won)
    
    {:noreply, socket}
  end


end
