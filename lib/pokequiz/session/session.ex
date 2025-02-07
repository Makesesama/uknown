defmodule Pokequiz.Session do
  alias __MODULE__

  defstruct players: [],
            state: :lobby,
            quiz: %{module: nil, finished: false},
            settings: %Pokequiz.Session.Settings{},
            rounds: [],
            max_rounds: 10,
            current_round: 1

  use GenServer

  @timeout 1_800_000

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

  @impl true
  def handle_cast({:update_settings, settings}, session) do
    {:noreply, Session.update_settings(session, settings), @timeout}
  end

  def handle_cast({:select_quiz, quiz}, session) do
    session =
      session
      |> Session.change_state(:game)
      |> Session.update_quiz(quiz)

    {:noreply, session, @timeout}
  end

  @impl true
  def handle_cast({:update_quiz, quiz}, session) do
    {:noreply, Session.update_quiz(session, quiz), @timeout}
  end

  def turn() do
  end

  def add_player(session, player) do
    players = session.players ++ [player]

    session
    |> Map.put(:players, players)
    |> Map.put(:rounds, Session.Round.generate_rounds(players, session.max_rounds))
  end

  def change_player(session, player) do
    players =
      Enum.map(session.players, fn x ->
        if x.name == player.name, do: player, else: x
      end)

    %{session | players: players}
  end

  def remove_player(session, name) do
    players = Enum.filter(session.players, fn x -> x.name != name end)
    %{session | players: players}
  end

  def change_state(session, state) do
    %{session | state: state}
  end

  def update_quiz(session, quiz) do
    %{session | quiz: quiz}
  end

  def update_settings(session, settings) do
    %{session | settings: settings}
  end
end
