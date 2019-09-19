defmodule ExPaint do
  @moduledoc false

  alias ExPaint.Image

  def create(w, h) when is_number(w) and is_number(h) do
    Image.start_link(width: w, height: h)
  end

  defdelegate destroy(image), to: Image
  defdelegate clear(image), to: Image
  defdelegate line(image, p1, p2, color), to: Image
  defdelegate rect(image, p, size, color), to: Image
  defdelegate filled_rect(image, p, size, color), to: Image
  defdelegate filled_ellipse(image, p, size, color), to: Image
  defdelegate filled_triangle(image, p1, p2, p3, color), to: Image
  defdelegate polygon(image, points, color), to: Image
  defdelegate arc(image, p1, p2, diam, color), to: Image
  defdelegate text(image, p, font, text, color), to: Image

  def render(image, rasterizer) do
    image
    |> Image.primitives()
    |> Enum.reduce(rasterizer.start(image), &rasterizer.apply/2)
    |> rasterizer.commit
  end
end
