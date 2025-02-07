defmodule Pokequiz.Session.Round do
  alias __MODULE__

  defstruct [:id, player: Pokequiz.Player, won: false]

  @typedoc "Number of Rounds"
  @type number_of_rounds() :: Integer.t()

  @spec generate_rounds(list(%Pokequiz.Player{}), number_of_rounds()) :: list(%Round{})
  def generate_rounds(players, number_of_rounds \\ 10) do
    extend_players(players, number_of_rounds)
    |> Enum.with_index()
    |> Enum.map(fn {player, i} ->
      %Round{id: i, player: player}
    end)
  end

  defp extend_players(players, number) do
    player_count = Enum.count(players)
    mult = ceil(number / player_count)

    List.duplicate(players, mult)
    |> List.flatten()
    |> Enum.split(number)
    |> elem(0)
  end
end
