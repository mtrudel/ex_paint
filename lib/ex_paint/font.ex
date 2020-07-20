defmodule ExPaint.Font do
  defstruct font: nil

  def load(fontname) do
    %__MODULE__{
      font: :egd_font.load(Path.join(:code.priv_dir(:ex_paint), "fonts/#{fontname}.wingsfont"))
    }
  end

  def size(%__MODULE__{font: font}) do
    :egd_font.size(font)
  end
end
