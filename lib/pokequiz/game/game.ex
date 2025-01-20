defmodule Pokequiz.Game do

  @callback init(socket :: %Phoenix.LiveView.Socket{}) :: %{}

  @callback display_name() :: String
  @callback value_handle() :: String

end
