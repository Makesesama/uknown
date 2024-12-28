defmodule Pokequiz.Repo do
  use Ecto.Repo,
    otp_app: :pokequiz,
    adapter: Ecto.Adapters.SQLite3
end
