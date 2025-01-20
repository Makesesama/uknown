defmodule Pokequiz.Components.Player do
  use Phoenix.Component
  import PokequizWeb.CoreComponents

  use Gettext, backend: PokequizWeb.Gettext
  
  def card(assigns) do
    ~H"""
    <div class={[
      "w-48 h-40 dark:bg-gunmetal grid border border-2 rounded rounded-lg max-w-sm p-6",
      if @current_player do "border-indian_red-500" else "border-mauve" end
      ]}
    >
      <h5 class="text-xl font-bold tracking-right">{@player.name} <%= if @current_player do "(" <> gettext("You") <> ")" end %> </h5>
        <p :if={!@friendly}>{gettext("Score")}: {@player.score}</p>

          <%= case @player.ready do %>
          <% false -> %>
          {gettext("Not Ready")}
          <% true -> %>
          {gettext("Ready")}
          <% end %>

          <.button :if={@current_player} class="bg-red-500" value={@player.name} phx-click="remove_player">{gettext("Remove")}</.button>
    </div>
    """
  end
end
