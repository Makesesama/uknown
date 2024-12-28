defmodule PokequizWeb.SessionsLive.Show do
  use PokequizWeb, :live_view

  alias Pokequiz.Quiz

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:sessions, Quiz.get_sessions!(id))}
  end

  defp page_title(:show), do: "Show Sessions"
  defp page_title(:edit), do: "Edit Sessions"
end
