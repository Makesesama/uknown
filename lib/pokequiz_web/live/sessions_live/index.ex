defmodule PokequizWeb.SessionsLive.Index do
  use PokequizWeb, :live_view

  alias Pokequiz.Quiz
  alias Pokequiz.Quiz.Sessions

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :quiz_sessions, Quiz.list_quiz_sessions())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Sessions")
    |> assign(:sessions, Quiz.get_sessions!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Sessions")
    |> assign(:sessions, %Sessions{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Quiz sessions")
    |> assign(:sessions, nil)
  end

  @impl true
  def handle_info({PokequizWeb.SessionsLive.FormComponent, {:saved, sessions}}, socket) do
    {:noreply, stream_insert(socket, :quiz_sessions, sessions)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    sessions = Quiz.get_sessions!(id)
    {:ok, _} = Quiz.delete_sessions(sessions)

    {:noreply, stream_delete(socket, :quiz_sessions, sessions)}
  end
end
