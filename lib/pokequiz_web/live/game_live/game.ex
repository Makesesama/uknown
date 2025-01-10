defmodule PokequizWeb.GameLive.Lobby do
  use PokequizWeb, :live_view

  import PokequizWeb.CoreComponents
  
  alias Pokequiz.Game

  def mount(_params, session, socket) do
    # We need to assign the value from the cookie in mount
    {:ok, assign(socket, user_cookie: session["user_cookie"])}
  end

  def handle_params(%{"name" => name} = _params, _, socket) do
    :ok = Phoenix.PubSub.subscribe(Pokequiz.PubSub, name)

    socket =
      socket
      |> assign_game(name)
      |> assign_player()
    
    {:noreply, socket}
  end
  
  def handle_params(_params, _uri, socket) do
    name =
      ?a..?z
      |> Enum.take_random(6)
      |> List.to_string()
  
    {:ok, _pid} =
      DynamicSupervisor.start_child(Pokequiz.GameSupervisor, {Game, name: via_tuple(name)})
  
    {:noreply,
     push_patch(
       socket,
       to: Phoenix.VerifiedRoutes.path(socket, PokequizWeb.Router, ~p"/lobby?name=#{name}")
     )}
  end

  @doc """
  Adds yourself to the player array and notifies all other players, that there is a new update.
  """
  def handle_event("add_player", %{"name" => player_name}, %{assigns: %{name: name, user_cookie: user_cookie}} = socket) do
    player = %Pokequiz.Player{name: player_name, session_cookie: user_cookie}
    socket =
      socket
      |> assign(player: player)
    
    :ok = GenServer.cast(via_tuple(name), {:add_player, player})
    :ok = Phoenix.PubSub.broadcast(Pokequiz.PubSub, name, :update)
    {:noreply, socket}
  end

  def handle_event("ready_player", _, %{assigns: %{name: name, player: player}} = socket) do
    player = %Pokequiz.Player{player | ready: !player.ready}
    socket =
      socket
      |> assign(player: player)
    
    :ok = GenServer.cast(via_tuple(name), {:ready_player, player})
    :ok = Phoenix.PubSub.broadcast(Pokequiz.PubSub, name, :update)
    {:noreply, socket}
  end

  def handle_event("start_game", _, %{assigns: %{name: name}} = socket) do
    :ok = GenServer.cast(via_tuple(name), {:change_state, :select})
    :ok = Phoenix.PubSub.broadcast(Pokequiz.PubSub, name, :update)
    {:noreply, socket}
  end

  def handle_event("remove_player", %{"value" => player_name}, %{assigns: %{name: name}} = socket) do
    :ok = GenServer.cast(via_tuple(name), {:remove_player, player_name})
    :ok = Phoenix.PubSub.broadcast(Pokequiz.PubSub, name, :update)
    {:noreply, socket}
  end

  def handle_event("select_quiz", %{"value" => quiz}, %{assigns: %{name: name}} = socket) do
    quiz_module = case quiz do
      "whois" -> PokequizWeb.WhoisLive.Show.startup()
    end
    
    :ok = GenServer.cast(via_tuple(name), {:select_quiz, quiz_module})
    :ok = Phoenix.PubSub.broadcast(Pokequiz.PubSub, name, :update)
    {:noreply, socket}
  end

  def handle_event("back_to_lobby", _, %{assigns: %{name: name}} = socket) do
    :ok = GenServer.cast(via_tuple(name), {:change_state, :lobby})
    :ok = Phoenix.PubSub.broadcast(Pokequiz.PubSub, name, :update)
    {:noreply, socket}
  end

  def handle_info(:update, socket) do
    socket =
      socket
      |> assign_game()
      |> check_kicked()
      |> update_player()
    {:noreply, socket}
  end
  
  defp via_tuple(name) do
    {:via, Registry, {Pokequiz.GameRegistry, name}}
  end
  
  defp assign_game(socket, name) do
    socket
    |> assign(name: name)
    |> assign_game()
  end
  
  defp assign_game(%{assigns: %{name: name}} = socket) do
    game = GenServer.call(via_tuple(name), :game)
    assign(socket, game: game)
  end

  defp assign_player(%{assigns: %{game: %{players: players}, user_cookie: user_cookie}} = socket) do
    player = Pokequiz.Player.restore_from_cookie(players, user_cookie)
    assign(socket, player: player)
  end

  defp update_player(%{assigns: %{game: %{players: players}, player: player}} = socket) do
    player = Pokequiz.Player.restore_from_name(players, player.name)
    IO.inspect(player)
    assign(socket, player: player) 
  end

  defp check_kicked(%{assigns: %{game: %{players: players}, player: player}} = socket) do
    if player do
      if Enum.find(players, fn x -> x.name == player.name end) == nil do
        push_navigate(socket, to: ~p"/lobby/kicked")
      else
        socket
      end
    else
      socket
    end
  end
  
end
