defmodule ExPaint.PNGRasterizer do
  @behaviour ExPaint.Rasterizer

  alias ExPaint.RGBRasterizer

  defdelegate start(image), to: RGBRasterizer
  defdelegate apply(primitive, state), to: RGBRasterizer

  def commit(state) do
    image = :egd.render(state, :png)
    :egd.destroy(state)
    {:ok, image}
  end
end
