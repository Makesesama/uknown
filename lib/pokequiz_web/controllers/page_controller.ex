defmodule PokequizWeb.PageController do
  use PokequizWeb, :controller

  import Logger
  alias Pokequiz.Repo
  alias Pokequiz.Dex.Pokemon
  
  def home(conn, _params) do
    pokemon =
      Repo.get(Pokemon, 112)
      |> Repo.preload(:types)

    # The home page is often custom made
    # so skip the default app layout.
    render(conn, :home, pokemon: pokemon)
  end

  def quiz(conn, _params) do
    types = Pokequiz.Dex.Type.get_random_kombo()
    # The home page is often custom made
    # so skip the default app layout.
    render(conn, :type_combi, pokemon: types)
  end
end
