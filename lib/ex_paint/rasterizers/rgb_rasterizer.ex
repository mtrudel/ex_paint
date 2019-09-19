defmodule ExPaint.RGBRasterizer do
  @behaviour ExPaint.Rasterizer

  alias ExPaint.{Image, Color, Font}

  def start(image) do
    {width, height} = Image.dimensions(image)
    :egd.create(width, height)
  end

  def apply(%ExPaint.Line{p1: p1, p2: p2, color: color}, state) do
    :egd.line(state, p1, p2, egd_color(color))
    state
  end

  def apply(%ExPaint.Rect{p: p, size: size, color: color}, state) do
    :egd.rectangle(state, p, size, egd_color(color))
    state
  end

  def apply(%ExPaint.FilledRect{p: p, size: size, color: color}, state) do
    :egd.filledRectangle(state, p, size, egd_color(color))
    state
  end

  def apply(%ExPaint.FilledEllipse{p: p, size: size, color: color}, state) do
    :egd.filledEllipse(state, p, size, egd_color(color))
    state
  end

  def apply(%ExPaint.FilledTriangle{p1: p1, p2: p2, p3: p3, color: color}, state) do
    :egd.filledTriangle(state, p1, p2, p3, egd_color(color))
    state
  end

  def apply(%ExPaint.Polygon{points: points, color: color}, state) do
    :egd.polygon(state, points, egd_color(color))
    state
  end

  def apply(%ExPaint.Arc{p1: p1, p2: p2, diam: diam, color: color}, state) do
    :egd.arc(state, p1, p2, diam, egd_color(color))
    state
  end

  def apply(%ExPaint.Text{p: p, font: %Font{font: font}, text: text, color: color}, state) do
    :egd.text(state, p, font, to_charlist(text), egd_color(color))
    state
  end

  def commit(state) do
    data = :egd.render(state, :raw_bitmap)
    :egd.destroy(state)
    {:ok, data}
  end

  defp egd_color(%Color{r: r, g: g, b: b}) do
    :egd.color({r, g, b})
  end
end
