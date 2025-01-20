defmodule Pokequiz.Session.Settings do
  alias __MODULE__

  defstruct [gens: :all, max_player: 4, password: nil, generations: [true, true, true, true, true, true, true, true, true]]
  
end
