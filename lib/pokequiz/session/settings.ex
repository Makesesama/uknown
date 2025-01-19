defmodule Pokequiz.Session.Settings do
  alias __MODULE__

  defstruct [gens: :all, max_player: 4, password: nil, generations: [1, 2, 3, 4, 5, 6, 7, 8, 9]]
  
end
