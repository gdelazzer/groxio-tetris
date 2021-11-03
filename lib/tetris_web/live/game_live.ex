defmodule TetrisWeb.GameLive do
  use TetrisWeb, :live_view
  alias Tetris.Tetromino

  def mount(_params, _session, socket) do
    :timer.send_interval(500, :tick)

    {
      :ok,
      socket
      |> new_tetromino
    }
  end

  def new_tetromino(socket) do
    assign(socket, tetro: Tetromino.new_random())
  end

  def render(assigns) do
    ~L"""
    <section class="phx-hero">
      <h1>Tetris</h1>
    </section>
    <% {x, y} = @tetro.location %>
    <pre>
      shape: <%= inspect @tetro.shape %>
      rotation: <%= inspect @tetro.rotation %>
      location: {<%= x %>, <%= y %>}
    </pre>
    """
  end

  def down(%{assigns: %{tetro: tetro}} = socket) do
    assign(socket, tetro: Tetromino.down(tetro))
  end

  def handle_info(:tick, socket) do
    {:noreply, down(socket)}
  end
end
