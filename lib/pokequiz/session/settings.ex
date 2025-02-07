defmodule Pokequiz.Session.Settings do
  alias __MODULE__

  defstruct gens: :all,
            max_player: 4,
            password: nil,
            generations: [
              one: true,
              two: true,
              three: true,
              four: true,
              five: true,
              six: true,
              seven: true,
              eight: true,
              nine: true
            ],
            friendly: false

  def generations_to_blacklist(generations) do
    Enum.filter(generations, fn {_, v} -> !v end)
    |> Enum.map(fn {k, _} ->
      case k do
        :one -> 1
        :two -> 2
        :three -> 3
        :four -> 4
        :five -> 5
        :six -> 6
        :seven -> 7
        :eight -> 8
        :nine -> 9
      end
    end)
  end
end
