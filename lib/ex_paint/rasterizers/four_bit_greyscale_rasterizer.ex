defmodule ExPaint.FourBitGreyscaleRasterizer do
  @behaviour ExPaint.Rasterizer

  use Bitwise, only_operators: true

  alias ExPaint.RGBRasterizer

  defdelegate start(image), to: RGBRasterizer
  defdelegate apply(primitive, state), to: RGBRasterizer

  def commit(state) do
    {:ok, data} = RGBRasterizer.commit(state)

    four_bit_data =
      data
      |> Stream.unfold(fn
        <<r, g, b, rest::binary>> -> {round(0.21 * r + 0.72 * g + 0.07 * b), rest}
        <<>> -> nil
      end)
      |> Enum.reduce(<<>>, fn b, acc -> <<acc::bitstring, b >>> 4::4>> end)

    {:ok, four_bit_data}
  end
end
