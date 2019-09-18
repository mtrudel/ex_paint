defmodule ExPaint do
  @moduledoc false

  use Bitwise, only_operators: true

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

  def render(image, format \\ :rgb_binary)

  def render(%Image{data: data}, :rgb_binary) do
    :egd.render(data, :raw_bitmap)
  end

  def render(%Image{} = image, :four_bit_greyscale) do
    image
    |> render
    |> Stream.unfold(fn
      <<r, g, b, rest::binary>> -> {round(0.21 * r + 0.72 * g + 0.07 * b), rest}
      <<>> -> nil
    end)
    |> Enum.reduce(<<>>, fn b, acc -> <<acc::bitstring, b >>> 4::4>> end)
  end

  def png(%Image{data: data}) do
    :egd.render(data, :png)
  end

  def inline(%Image{w: w, h: h} = image) do
    IO.write(
      :stderr,
      "\e]1337;File=inline=1;width=#{w}px;height=#{h}px:#{image |> png |> Base.encode64()}\a\n"
    )
  end
end
