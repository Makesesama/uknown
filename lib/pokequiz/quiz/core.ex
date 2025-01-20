defmodule Pokequiz.Game do

  @callback init() :: %{}

  @callback display_name() :: String
  @callback value_handle() :: String

end
