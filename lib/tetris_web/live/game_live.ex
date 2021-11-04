defmodule TetrisWeb.GameLive do
  use TetrisWeb, :live_view
  alias Tetris.Game

  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(500, :tick)
    end

    {:ok, new_game(socket)}
  end

  def render(assigns) do
    ~L"""
    <section class="phx-hero">
      <div phx-window-keydown="keystroke">
        <h1>Tetris</h1>
        <h2><%= @game.score %></h2>
        <%= render_board(assigns) %>
      </div>
    </section>
    <% {x, y} = @game.tetro.location %>
    <pre>
      Location: <%= x %>, <%= y %>
      <%= inspect @game %>
    </pre>
    """
  end

  defp render_board(assigns) do
    ~L"""
    <svg width="200" height="400">
      <rect width="200" height="400" style="fill:black;" />
      <%= render_points(assigns) %>
    </svg>
    """
  end

  defp render_points(assigns) do
    ~L"""
    <%= for {x, y, shape} <- @game.points ++ Game.junkyard(@game) do %>
      <rect
        width="20" height="20"
        style="fill:<%= color(shape) %>;"
        x="<%= (x - 1) * 20 %>"
        y="<%= (y - 1) * 20 %>" />
    <% end %>
    """
  end

  defp color(:l), do: "red"
  defp color(:j), do: "saddlebrown"
  defp color(:s), do: "gray"
  defp color(:z), do: "aqua"
  defp color(:o), do: "coral"
  defp color(:i), do: "goldenrod"
  defp color(:t), do: "limegreen"
  defp color(_), do: "red"

  defp new_game(socket) do
    assign(socket, game: Game.new())
  end

  defp new_tetromino(socket) do
    assign(socket, game: Game.new_tetromino(socket.assigns.game))
  end

  def down(%{assigns: %{game: game}} = socket) do
    assign(socket, game: Game.down(game))
  end

  def rotate(%{assigns: %{game: game}} = socket) do
    socket
    |> assign(game: Game.rotate(game))
  end

  def left(%{assigns: %{game: game}} = socket) do
    socket
    |> assign(game: Game.left(game))
  end

  def right(%{assigns: %{game: game}} = socket) do
    socket
    |> assign(game: Game.right(game))
  end

  def handle_info(:tick, socket) do
    {:noreply, socket |> down}
  end

  def handle_event("keystroke", %{"key" => " "}, socket) do
    {:noreply, socket |> rotate}
  end

  def handle_event("keystroke", %{"key" => "ArrowLeft"}, socket) do
    {:noreply, socket |> left}
  end

  def handle_event("keystroke", %{"key" => "ArrowRight"}, socket) do
    {:noreply, socket |> right}
  end

  def handle_event("keystroke", %{"key" => "ArrowDown"}, socket) do
    {:noreply, socket |> down}
  end

  def handle_event("keystroke", _, socket) do
    {:noreply, socket}
  end
end
