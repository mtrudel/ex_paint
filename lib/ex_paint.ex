defmodule ExPaint do
  @moduledoc """
  ExPaint provides simple primitive based drawing abilities with a flexible backend
  system for raterizing.
  """

  alias ExPaint.Image

  @doc """
  Creates an image reference of the given size into which primitives may be 
  drawn, and which may be rendered to a given format.
  """
  def create(w, h) when is_number(w) and is_number(h) do
    Image.start_link(width: w, height: h)
  end

  @doc """
  Frees the internal resources being used by the given image.
  """
  defdelegate destroy(image), to: Image

  @doc """
  Removes all queued drawing primitives for this image. Images have an 
  all-white background when empty.
  """
  defdelegate clear(image), to: Image

  @doc """
  Enqueues a line from p1 to p2 of the given color

  ## Parameters

  * image: An image reference to draw into
  * p1: A `{x,y}` integer tuple of the starting point of the line
  * p2: A `{x,y}` integer tuple of the ending point of the line
  * color: A ExPaint.Color struct describing the color of the line
  """
  defdelegate line(image, p1, p2, color), to: Image

  @doc """
  Enqueues a rect of the given size and color whose upper left corner is at p

  ## Parameters

  * image: An image reference to draw into
  * p: A `{x,y}` integer tuple of the upper left corner of the rectangle
  * size: A `{w,h}` integer tuple of the outer size of the rectangle
  * color: A ExPaint.Color struct describing the color of the rectangle's border
  """
  defdelegate rect(image, p, size, color), to: Image

  @doc """
  Enqueues a filled rect of the given size and color whose upper left corner 
  is at p

  ## Parameters

  * image: An image reference to draw into
  * p: A `{x,y}` integer tuple of the upper left corner of the rectangle
  * size: A `{w,h}` integer tuple of the outer size of the rectangle
  * color: A ExPaint.Color struct describing the color of the rectangle's fill
  """
  defdelegate filled_rect(image, p, size, color), to: Image

  @doc """
  Enqueues a filled ellipse of the given size and color whose bounding box's upper left 
  corner is at p 

  ## Parameters

  * image: An image reference to draw into
  * p: A `{x,y}` integer tuple of the upper left corner of the ellipse's bounding box
  * size: A `{w,h}` integer tuple of the outer size of the ellipse's bounding box
  * color: A ExPaint.Color struct describing the color of the ellipse's fill
  """
  defdelegate filled_ellipse(image, p, size, color), to: Image

  @doc """
  Enqueues a filled triangle of the given color with the specified vertices. Winding
  of the vertices does not matter

  ## Parameters

  * image: An image reference to draw into
  * p1: A `{x,y}` integer tuple of the first point of the triangle
  * p2: A `{x,y}` integer tuple of the second point of the triangle
  * p3: A `{x,y}` integer tuple of the third point of the triangle
  * color: A ExPaint.Color struct describing the color of the triangle's fill
  """
  defdelegate filled_triangle(image, p1, p2, p3, color), to: Image

  @doc """
  Enqueues a polygon with an arbitrary number of vertices. Winding of the vertices 
  does not matter

  ## Parameters

  * image: An image reference to draw into
  * points: A list of `{x,y}` integer tuples, one for each vertex
  * color: A ExPaint.Color struct describing the color of the polygon's border
  """
  defdelegate polygon(image, points, color), to: Image

  @doc """
  Enqueues an arc with the given two points on its radius and the given diameter

  ## Parameters

  * image: An image reference to draw into
  * p1: A `{x,y}` integer tuple of a point on the arc's raduis
  * p2: A `{x,y}` integer tuple of a second point on the arc's raduis
  * diam: An integer value for the arc's diameter
  * color: A ExPaint.Color struct describing the color of the arc's border
  """
  defdelegate arc(image, p1, p2, diam, color), to: Image

  @doc """
  Enqueues a text string 

  Parameters:
  * image: An image reference to draw into
  * p: A `{x,y}` integer tuple of the upper left point of the text's bounding box
  * font: A ExPaint.Font struct describing the font to use
  * text: The string to display
  * color: A ExPaint.Color struct describing the color of the text
  """
  defdelegate text(image, p, font, text, color), to: Image

  @doc """
  Renders the given image according to the given rasterizer

  ## Parameters

  * image: An image reference to draw into
  * rasterizer: The rasterizer module to use to produce the output.

  ## Examples

  iex> ExPaint.render(image, ExPaint.PNGRasterizer)
       {:ok, png_data}
  """
  def render(image, rasterizer) do
    image
    |> Image.primitives()
    |> Enum.reduce(rasterizer.start(image), &rasterizer.apply/2)
    |> rasterizer.commit
  end
end
