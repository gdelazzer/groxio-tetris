defmodule TetrisWeb.GameLive do
  use TetrisWeb, :live_view
  alias Tetris.Tetromino

  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(500, :tick)
    end

    {
      :ok,
      socket
      |> new_tetromino
      |> show
    }
  end

  def render(assigns) do
    ~L"""
    <section class="phx-hero">
      <h1>Tetris</h1>
      <%= render_board(assigns) %>
    </section>
    <% {x, y} = @tetro.location %>
    <pre>
      Location: <%= x %>, <%= y %>
      <%= inspect @tetro %>
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
    <%= for {x, y, shape} <- @points do %>
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

  defp new_tetromino(socket) do
    assign(socket, tetro: Tetromino.new_random())
  end

  defp show(socket) do
    assign(socket,
      points: Tetromino.show(socket.assigns.tetro)
    )
  end

  def down(%{assigns: %{tetro: %{location: {_, 20}}}} = socket) do
    socket
    |> new_tetromino
    |> show
  end

  def down(%{assigns: %{tetro: tetro}} = socket) do
    assign(socket, tetro: Tetromino.down(tetro))
  end

  def handle_info(:tick, socket) do
    {:noreply, socket |> down |> show}
  end
end
