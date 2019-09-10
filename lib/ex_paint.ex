defmodule ExPaint do
  @moduledoc false

  use Bitwise, only_operators: true

  alias ExPaint.{Image, Font, Color}

  def create(w, h) when is_number(w) and is_number(h) do
    %Image{w: w, h: h, data: :egd.create(w, h)}
  end

  def destroy(%Image{data: data}) do
    :egd.destroy(data)
  end

  def clear(%Image{w: w, h: h} = image, color \\ Color.black()) do
    filled_rect(image, {0, 0}, {w, h}, color)
  end

  def line(%Image{data: data}, p1, p2, %Color{r: r, g: g, b: b}) do
    :egd.line(data, p1, p2, :egd.color({r, g, b}))
  end

  def text(%Image{data: data}, p, %Font{font: font}, text, %Color{r: r, g: g, b: b}) do
    :egd.text(data, p, font, to_charlist(text), :egd.color({r, g, b}))
  end

  def rect(%Image{data: data}, {x, y}, {w, h}, %Color{r: r, g: g, b: b}) do
    :egd.rectangle(data, {x, y}, {x + w - 1, y + h - 1}, :egd.color({r, g, b}))
  end

  def filled_rect(%Image{data: data}, {x, y}, {w, h}, %Color{r: r, g: g, b: b}) do
    :egd.filledRectangle(data, {x, y}, {x + w - 1, y + h - 1}, :egd.color({r, g, b}))
  end

  def filled_ellipse(%Image{data: data}, {x, y}, {w, h}, %Color{r: r, g: g, b: b}) do
    :egd.filledEllipse(data, {x, y}, {x + w - 1, y + h - 1}, :egd.color({r, g, b}))
  end

  def filled_triangle(%Image{data: data}, p1, p2, p3, %Color{r: r, g: g, b: b}) do
    :egd.filledTriangle(data, p1, p2, p3, :egd.color({r, g, b}))
  end

  def polygon(%Image{data: data}, points, %Color{r: r, g: g, b: b}) do
    :egd.polygon(data, points, :egd.color({r, g, b}))
  end

  def arc(%Image{data: data}, p1, p2, diam, %Color{r: r, g: g, b: b}) do
    :egd.arc(data, p1, p2, diam, :egd.color({r, g, b}))
  end

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
