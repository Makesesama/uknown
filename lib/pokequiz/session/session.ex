defmodule Pokequiz.Session do

  alias __MODULE__
  alias Pokequiz.Player

  defstruct [players: [], turn: 0, state: :lobby, quiz: %{module: nil, finished: false}, settings: %Pokequiz.Session.Settings{}]
  
  use GenServer

  @states [:lobby, :select, :game]
  @timeout 1800000
 
  def start_link(options) do
    GenServer.start_link(__MODULE__, %Session{}, options)
  end
 
  @impl true
  def init(session) do
    {:ok, session, @timeout}
  end
 
  @impl true
  def handle_call(:session, _from, session) do
    {:reply, session, session, @timeout}
  end
 
  # @impl true
  # def handle_cast({:place, position}, game) do
  #   {:noreply, Game.place(game, position)}
  # end

  @impl true
  def handle_cast({:add_player, player}, session) do
    {:noreply, Session.add_player(session, player), @timeout}
  end

  @impl true
  def handle_cast({:ready_player, player}, session) do
    {:noreply, Session.change_player(session, player), @timeout}
  end

  @impl true
  def handle_cast({:remove_player, player_name}, session) do
    {:noreply, Session.remove_player(session, player_name), @timeout}
  end

  @impl true
  def handle_cast({:change_player, player}, session) do
    {:noreply, Session.change_player(session, player), @timeout}
  end

  @impl true
  def handle_cast({:change_state, state}, session) do
    {:noreply, Session.change_state(session, state), @timeout}
  end

  def handle_cast({:select_quiz, quiz}, session) do
    session =
      session
      |> Session.change_state(:game)
      |> Session.set_quiz(quiz)
    {:noreply, session, @timeout}
  end

  @impl true
  def handle_cast({:update_quiz, quiz}, session) do
    {:noreply, Session.update_quiz(session, quiz), @timeout}
  end
 
  # @impl true
  # def handle_cast({:jump, destination}, session) do
  #   {:noreply, Session.jump(session, destination)}
  # end
 
  def turn() do
  end


  def add_player(session, player) do
    %{session | players: session.players ++ [player]}
  end


  def change_player(session, player) do
    players = Enum.map(session.players, fn x ->
      if x.name == player.name, do: player, else: x end)

    %{session | players: players}
  end

  def remove_player(session, name) do
    players = Enum.filter(session.players, fn x -> x.name != name end)
    %{session | players: players}
  end

  def change_state(session, state) do
    %{session | state: state}
  end

  def set_quiz(session, quiz) do
    %{session | quiz: quiz}
  end

  def update_quiz(session, quiz) do
    %{session | quiz: quiz}
  end
  
end
