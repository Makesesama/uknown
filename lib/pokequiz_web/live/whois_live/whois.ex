defmodule PokequizWeb.WhoisLive.Show do
  # In a typical Phoenix app, the following line would usually be `use MyAppWeb, :live_view`
  use PokequizWeb, :live_component

  import Pokequiz.Session.Helper
  import PokequizWeb.CoreComponents

  alias Pokequiz.Dex

  def display_name(), do: "Who is that Pokemon?"
  def value_handle(), do: "whois"

  def render(assigns) do
    ~H"""
    <div>
      <div class="relative">
        <img class="2xl:w-fit" width="100%" height="100%" alt="Unkown Pokemon" src={"/images/whois.png"} />
        <img class={[@quiz.pick, "2xl:w-4/12"]} width="40%" height="40%" alt="Unkown Pokemon" src={Dex.Pokemon.image(@quiz.pokemon)} />

        <form :if={@player && !@quiz.finished} class="absolute bottom-4 left-56 text-black font-bold text-xl p-2 rounded flex justify-center gap-2" phx-submit="submit" phx-change="completion" phx-target={@myself}>
          <label>Your Guess:<.input list="pokemon-names" errors={@input_error} class={["rounded", "border-2"]} id="msg" type="text" name="input_value" value="" autofocus="true"/></label>
          <button class="bg-blue-500 hover:bg-blue-700 border border-2 border-black text-white font-bold py-2 px-4 rounded rounded-lg">Send<.icon name="hero-paper-airplane-mini" class="w-4 h-4" /></button>
        </form>

        <.modal id="confirm-modal">
          <div class="text-black">
            Do you really want to the next?
            <button :if={@player && @quiz.finished} phx-click={hide_modal("confirm-modal") |> JS.push("new")} class="absolute bottom-4 left-56 bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded" phx-target={@myself}>Next</button>
          </div>
        </.modal>

        <button :if={@player && @quiz.finished}  phx-click={show_modal("confirm-modal")} class="absolute bottom-4 left-56 bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">Next</button>


        <p class="absolute origin-center -rotate-12 text-4xl font-bold text-yellow-400 right-[20%] top-[35%]" :if={@quiz.finished}>{@quiz.pokemon.name}</p>
      </div>



      <datalist id="pokemon-names">
        <%= for data <- @datalist do %>
        <option value={data.name}></option>
        <%end %>
      </datalist>
    </div>
    """
  end
  
  def handle_event("new", _, socket) do
    %{assigns: %{quiz: quiz, name: name}} = socket
    quiz =
      quiz
      |> Map.put(:pokemon, Dex.Pokemon.random())
      |> Map.put(:pick, "absolute top-8 left-[8%] filter brightness-0")
      |> Map.put(:finished, false)
    
    notify_other(name, quiz)
    
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
            "absolute transition duration-1000 top-8 left-[8%] filter"
          String.downcase(Enum.at(pokemon.species.names, 5).name) == String.downcase(msg) ->
            "absolute transition duration-1000 top-8 left-[8%] filter"
          true ->
            "absolute transition duration-1000 top-8 left-[8%] filter brightness-0"
        end
        
      finished = String.downcase(pokemon.name) == String.downcase(msg) or  String.downcase(Enum.at(pokemon.species.names, 5).name) == String.downcase(msg)

      quiz =
        quiz
        |> Map.put(:pick, picked)
        |> Map.put(:finished, finished)

      notify_other(name, quiz)

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
    |> Map.put(:pick, "absolute transition duration-1000 top-8 left-[8%] filter brightness-0")
    |> Map.put(:finished, false)
  end

end
