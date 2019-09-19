defmodule ExPaint.InlineRasterizer do
  @behaviour ExPaint.Rasterizer

  alias ExPaint.PNGRasterizer

  def start(image) do
    {width, height} = ExPaint.Image.dimensions(image)
    png_state = PNGRasterizer.start(image)
    {width, height, png_state}
  end

  def apply(primitive, {width, height, png_state}) do
    {width, height, PNGRasterizer.apply(primitive, png_state)}
  end

  def commit({width, height, png_state}) do
    {:ok, png} = PNGRasterizer.commit(png_state)

    IO.write(
      :stderr,
      "\e]1337;File=inline=1;width=#{width}px;height=#{height}px:#{png |> Base.encode64()}\a\n"
    )
  end
end
