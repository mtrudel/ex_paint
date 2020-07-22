defmodule ExPaint.Font do
  defstruct font: nil

  def load(fontname) do
    %__MODULE__{
      font: :egd_font.load(Path.join(:code.priv_dir(:ex_paint), "fonts/#{fontname}.wingsfont"))
    }
  end

  @doc """
  Returns the (fixed) size of a glyph. Our underlying font library
  only seems to care about cap height, and so doesn't take into account descenders. 
  We add a descender height to the returned size as passed in, defaulting to 0.3 of
  cap height
  """
  def size(%__MODULE__{font: font}, descender_height \\ 0.3) do
    {width, cap_height} = :egd_font.size(font)
    {width, ceil(cap_height * (1 + descender_height))}
  end
end
