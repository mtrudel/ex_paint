defmodule ExPaint.Image do
  @moduledoc false

  @type t :: pid

  use GenServer

  alias ExPaint.{Color, Font}

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts)
  end

  def destroy(pid) do
    GenServer.stop(pid)
  end

  def dimensions(pid) do
    GenServer.call(pid, :dimensions)
  end

  def clear(pid) do
    GenServer.call(pid, :clear)
  end

  def line(pid, {_x1, _y1} = p1, {_x2, _y2} = p2, %Color{} = color) do
    %ExPaint.Line{p1: p1, p2: p2, color: color}
    |> send_to(pid)
  end

  def rect(pid, {_x1, _y1} = p, {_w, _h} = size, %Color{} = color) do
    %ExPaint.Rect{p: p, size: size, color: color}
    |> send_to(pid)
  end

  def filled_rect(pid, {_x1, _y1} = p, {_w, _h} = size, %Color{} = color) do
    %ExPaint.FilledRect{p: p, size: size, color: color}
    |> send_to(pid)
  end

  def filled_ellipse(pid, {_x1, _y1} = p, {_w, _h} = size, %Color{} = color) do
    %ExPaint.FilledEllipse{p: p, size: size, color: color}
    |> send_to(pid)
  end

  def filled_triangle(pid, {_x1, _y1} = p1, {_x2, _y2} = p2, {_x3, _y3} = p3, %Color{} = color) do
    %ExPaint.FilledTriangle{p1: p1, p2: p2, p3: p3, color: color}
    |> send_to(pid)
  end

  def polygon(pid, points, %Color{} = color) do
    %ExPaint.Polygon{points: points, color: color}
    |> send_to(pid)
  end

  def arc(pid, {_x1, _y1} = p1, {_x2, _y2} = p2, diam, %Color{} = color) do
    %ExPaint.Arc{p1: p1, p2: p2, diam: diam, color: color}
    |> send_to(pid)
  end

  def text(pid, {_x1, _y1} = p, %Font{} = font, text, %Color{} = color) do
    %ExPaint.Text{p: p, font: font, text: text, color: color}
    |> send_to(pid)
  end

  def primitives(pid) do
    GenServer.call(pid, :primitives)
  end

  defp send_to(primitive, pid) do
    GenServer.call(pid, {:add_primitive, primitive})
  end

  def init(opts) do
    with {:width, width} when is_number(width) <- {:width, Keyword.get(opts, :width)},
         {:height, height} when is_number(height) <- {:height, Keyword.get(opts, :height)} do
      {:ok, %{width: width, height: height, primitives: []}}
    else
      {missing, _} -> {:stop, "Missing or invalid value for #{missing}"}
    end
  end

  def handle_call(:clear, _from, state) do
    {:reply, :ok, %{state | primitives: []}}
  end

  def handle_call(:dimensions, _from, %{width: width, height: height} = state) do
    {:reply, {width, height}, state}
  end

  def handle_call({:add_primitive, primitive}, _from, state) do
    {:reply, :ok, Map.update!(state, :primitives, fn primitives -> [primitive | primitives] end)}
  end

  def handle_call(:primitives, _from, %{primitives: primitives} = state) do
    {:reply, Enum.reverse(primitives), state}
  end
end
