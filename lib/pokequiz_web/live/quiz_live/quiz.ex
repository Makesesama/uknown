defmodule PokequizWeb.QuizLive.Show do
  # In a typical Phoenix app, the following line would usually be `use MyAppWeb, :live_view`
  use Phoenix.LiveView

  import PokequizWeb.CoreComponents
  
  def render(assigns) do
    ~H"""
    <div class="flex justify-center">
      <div>
        <p>There are {Enum.count(@pokemon.pokemon)} with the type Combination <%= for type <- @pokemon.types do %>{type} <% end %></p>

      <form phx-submit="submit">
        <label>Your Text:<input id="msg" type="text" name="input_value" /></label>
        <button>Send</button>
      </form>
      <%= if @pick do %>
      <p>Your pick is {@pick}</p>
      <% end %>
      <div>

        <%= for pokemon <- @pokemon.pokemon do %>
        <%= if pokemon.picked do %>
        <.list>
          <:item title="Name">{pokemon.name}</:item>
          <:item title="Types">{Enum.map(pokemon.types, fn x -> "#{x.name} " end)}</:item>
        </.list>
        <% end %>
        <% end %>
      
      </div>
      </div>
    </div>
    """
  end

  def mount(params, session, socket) do
    #TODO Sometimes this gets a weird type Kombo like normal nil
    types = Pokequiz.Dex.Type.get_random_kombo()
    IO.inspect(types)
    socket =
      socket
      |> assign(pokemon: types)
      |> assign_new(:pick, fn -> nil end)

    {:ok, socket}
  end

  def handle_event("submit", %{"input_value" => msg}, socket) do
    %{assigns: %{pokemon: pokemon}} = socket
    %{assigns: %{pick: old_pick}} = socket
    
    pick =
      pokemon.pokemon
      |> Enum.filter(fn x -> x.name == msg end)

    pick_name = if Enum.count(pick) > 0 do
                  pick
                  |> hd
                  |> Map.get(:name)                  
                else
                  nil
    end

    # new_pokemon = put_in(pokemon.pokemon[pick_name].picked, true)


    if old_pick == nil do
      socket =
        socket
        |> assign(:pick, [pick_name])
        # |> assign(:pokemon, %{pokemon: new_pokemon, types: pokemon.types})
      {:noreply, socket}
    else
      socket =
        socket
        |> assign(:pick, [pick_name|old_pick])
        # |> assign(:pokemon, %{pokemon: new_pokemon, types: pokemon.types})
      {:noreply, socket}
    end

  end

end
