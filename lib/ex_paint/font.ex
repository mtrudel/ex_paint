defmodule ExPaint.Font do
  defstruct font: nil

  def load(fontname) do
    %__MODULE__{
      font: :egd_font.load(Application.app_dir(:ex_paint, "priv/fonts/#{fontname}.wingsfont"))
    }
  end

  def size(%__MODULE__{font: font}) do
    :egd_font.size(font)
  end
end
