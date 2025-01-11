defmodule PokequizWeb.HomeLive do
  # In a typical Phoenix app, the following line would usually be `use MyAppWeb, :live_view`
  use PokequizWeb, :live_view
  
  import PokequizWeb.CoreComponents

  def render(assigns) do
    ~H"""
    <.flash_group flash={@flash} />
<div class="flex flex-wrap">
    <div class="w-full sm:w-8/12 mb-10">
      <div class="container mx-auto h-full sm:p-10">
        <nav class="flex px-4 justify-between items-center">
          <div class="text-4xl font-bold">
            <span class="text-green-700"></span>
          </div>
          <div>
            <img src="https://image.flaticon.com/icons/svg/497/497348.svg" alt="" class="w-8">
            </div>
          </nav>
          <header class="container px-4 lg:flex mt-10 items-center h-full lg:mt-0">
            <div class="w-full">
              <h1 class="text-4xl lg:text-6xl font-bold">Catch Your Friends like Pokemon</h1>
              <div class="w-20 h-2 bg-mauve-700 my-4"></div>
              <p class="text-xl mb-10">Play Pokemon Quizzes like "Who is that Pokemon" or "Which Pokemon is heavier".</p>
              <div class="container flex justify-center mx-auto">
                <div class="flex flex-col justify-center gap-2 min-w-80">
                  <div class="grid justify-center">
                    <button class="bg-mauve/80 text-black text-2xl font-medium px-4 py-2 rounded shadow" >
                      <.link href="/lobby">Open new Lobby</.link>
                    </button>
                    <div class="flex justify-center">
                      <p class="font-bold p-2">or</p>
                    </div>
                    <div>
                      <button>
                        <form class="bottom-4 left-56 p-2 rounded flex justify-center gap-2" phx-submit="join_lobby">
                          <.input id="join_lobby" type="text" name="lobby_input" value="" minlength="6" placeholder="Input Code here to join"/>
                          <button class="bg-indian_red-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">Send<.icon name="hero-paper-airplane-mini" class="w-4 h-4" /></button>
                        </form>
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </header>
        </div>
      </div>
      <div class="max-h-100% overflow-hidden w-full h-48 object-cover sm:h-screen sm:w-4/12 bg-gunmetal-400">
        <div class="w-full flex justify-center">
          <div class="max-w-40 h-full">
            <div class="h-full w-40 flex flex-col [mask-image:_linear-gradient(to_top,transparent_0,_black_128px,_black_calc(100%-200px),transparent_100%)]">
              <%= for _ <- 1..2 do %>
              <ul class="grid grid-cols-1 gap-4 items-center justify-center md:justify-start animate-infinite-scroll pb-4">
                <%= for pokemon <- @pokemon do %>
                <li class="w-40 border border-2 border-mauve-400 rounded rounded-lg z-10">
                  <img class="w-40 h-40 z-10" width="40%" height="40%" alt={pokemon.name} src={Pokequiz.Dex.Pokemon.image(pokemon)} />
                </li>
                <% end %>
              </ul>
              <% end %>
            </div>
            
          </div>
        </div>
      </div>
    </div>
    """
  end
  
  def mount(_params, session, socket) do
    # We need to assign the value from the cookie in mount
    socket =
      socket
      |>assign(:pokemon, Pokequiz.Dex.Pokemon.random(8))
    {:ok, socket}
  end

  @doc """
  """
  def handle_event("join_lobby",%{"lobby_input" => url},  socket) do
    {:noreply,
     redirect(
       socket,
       to: extract(url)
     )}
  end

  defp extract(url) do
    IO.inspect(URI.parse(url))
    case URI.parse(url) do
      %URI{host: nil} -> "/lobby?name=#{url}"
      %URI{path: path} = %URI{host: "localhost"} -> path
      %URI{} -> "/"
    end
  end
  
end
