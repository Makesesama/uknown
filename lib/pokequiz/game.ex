defmodule Pokequiz.Game do

  alias __MODULE__
  alias Pokequiz.Player

  defstruct [players: [], turn: 0, state: :lobby, quiz: %{module: nil, finished: false}]
  
  use GenServer

  @states [:lobby, :select, :game]
 
  def start_link(options) do
    GenServer.start_link(__MODULE__, %Game{}, options)
  end
 
  @impl true
  def init(game) do
    {:ok, game}
  end
 
  @impl true
  def handle_call(:game, _from, game) do
    {:reply, game, game}
  end
 
  # @impl true
  # def handle_cast({:place, position}, game) do
  #   {:noreply, Game.place(game, position)}
  # end

  @impl true
  def handle_cast({:add_player, player}, game) do
    {:noreply, Game.add_player(game, player)}
  end

  @impl true
  def handle_cast({:ready_player, player}, game) do
    {:noreply, Game.change_player(game, player)}
  end

  @impl true
  def handle_cast({:remove_player, player_name}, game) do
    {:noreply, Game.remove_player(game, player_name)}
  end

  @impl true
  def handle_cast({:change_player, player}, game) do
    {:noreply, Game.change_player(game, player)}
  end

  @impl true
  def handle_cast({:change_state, state}, game) do
    {:noreply, Game.change_state(game, state)}
  end

  def handle_cast({:select_quiz, quiz}, game) do
    game =
      game
      |> Game.change_state(:game)
      |> Game.set_quiz(quiz)
    {:noreply, game}
  end

  @impl true
  def handle_cast({:update_quiz, quiz}, game) do
    {:noreply, Game.update_quiz(game, quiz)}
  end
 
  # @impl true
  # def handle_cast({:jump, destination}, game) do
  #   {:noreply, Game.jump(game, destination)}
  # end
 
  def turn() do
  end


  def add_player(game, player) do
    %{game | players: game.players ++ [player]}
  end


  def change_player(game, player) do
    players = Enum.map(game.players, fn x ->
      if x.name == player.name, do: player, else: x end)

    %{game | players: players}
  end

  def remove_player(game, name) do
    players = Enum.filter(game.players, fn x -> x.name != name end)
    %{game | players: players}
  end

  def change_state(game, state) do
    %{game | state: state}
  end

  def set_quiz(game, quiz) do
    %{game | quiz: quiz}
  end

  def update_quiz(game, quiz) do
    %{game | quiz: quiz}
  end
  
end
