defmodule ExPaint.Color do
  defstruct r: 0, g: 0, b: 0

  def black, do: %__MODULE__{}
  def white, do: %__MODULE__{r: 255, g: 255, b: 255}
end
