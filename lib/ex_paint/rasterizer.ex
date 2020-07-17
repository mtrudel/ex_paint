defmodule ExPaint.Rasterizer do
  @moduledoc false

  @type state :: any
  @type raster :: binary

  @callback start(ExPaint.Image.t()) :: state
  @callback apply(ExPaint.ImagePrimitive.t(), state) :: state
  @callback commit(state) :: {:ok, raster} | {:error, String.t()}
end
