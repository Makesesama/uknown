defmodule PokequizWeb.SessionsLive.FormComponent do
  use PokequizWeb, :live_component

  alias Pokequiz.Quiz

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage sessions records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="sessions-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:players]} type="number" label="Players" />
        <.input field={@form[:game_master]} type="checkbox" label="Game master" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Sessions</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{sessions: sessions} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Quiz.change_sessions(sessions))
     end)}
  end

  @impl true
  def handle_event("validate", %{"sessions" => sessions_params}, socket) do
    changeset = Quiz.change_sessions(socket.assigns.sessions, sessions_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"sessions" => sessions_params}, socket) do
    save_sessions(socket, socket.assigns.action, sessions_params)
  end

  defp save_sessions(socket, :edit, sessions_params) do
    case Quiz.update_sessions(socket.assigns.sessions, sessions_params) do
      {:ok, sessions} ->
        notify_parent({:saved, sessions})

        {:noreply,
         socket
         |> put_flash(:info, "Sessions updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_sessions(socket, :new, sessions_params) do
    case Quiz.create_sessions(sessions_params) do
      {:ok, sessions} ->
        notify_parent({:saved, sessions})

        {:noreply,
         socket
         |> put_flash(:info, "Sessions created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
