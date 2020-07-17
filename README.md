# ExPaint

[![Build Status](https://travis-ci.org/mtrudel/ex_paint.svg?branch=master)](https://travis-ci.org/mtrudel/ex_paint)
[![Inline docs](http://inch-ci.org/github/mtrudel/ex_paint.svg?branch=master&style=flat)](http://inch-ci.org/github/mtrudel/ex_paint)
[![Hex.pm](https://img.shields.io/hexpm/v/ex_paint.svg?style=flat-square)](https://hex.pm/packages/ex_paint)

ExPaint is a simple 2D rasterizer, based (for now, at least) on the [egd](https://github.com/erlang/egd) library.
Available primitives include lines, rectangles, arcs, polygons, and simple bitmap font support. Dumping of the
resulting bitmap is supported in a few forms, including a 4-bit greyscale format as used by devices such as [SSD1322
based OLED displays](https://github.com/mtrudel/ssd1322).

The library leans heavily on egd for now, but the eventual intent is to implement an optimized retained mode backing
store using something like a piece table of binaries to provide performant compositing / dumping.

## Usage

```elixir
alias ExPaint.{Font, Color}

{:ok, image} = ExPaint.create(128, 64)
font = Font.load("Helvetica20")

ExPaint.clear(image)

ExPaint.text(image, {10, 30}, font, "Hello World", Color.black())
ExPaint.filled_rect(image, {10, 10}, {20,20}, %Color{r: 230, g: 12, b: 34})
ExPaint.filled_ellipse(image, {50, 10}, {20,20}, %Color{r: 12, g: 12, b: 230})
ExPaint.filled_triangle(image, {90, 30}, {100, 10}, {110, 30}, %Color{r: 230, g: 230, b: 34})

# Write to a png
File.write("foo.png", ExPaint.render(image, ExPaint.PNGRasterizer))

# If you're in iTerm, display inline
ExPaint.render(image, ExPaint.InlineRasterizer)

# If you're pairing with https://github.com/mtrudel/ssd1322
SSD1322.draw(session, ExPaint.render(image, ExPaint.FourBitGreyscaleRasterizer))
```

will render the following image:

![foo](https://user-images.githubusercontent.com/79646/78073774-864d5300-736f-11ea-9acb-8eff03b20a22.png)


## Installation

This package can be installed by adding `ex_paint` and `egd` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_paint, "~> 0.1.0"},
    {:egd, github: "erlang/egd"}
  ]
end
```

Docs can be found at [https://hexdocs.pm/ex_paint](https://hexdocs.pm/ex_paint).

## Credits

For ease of installation, this package includes the contents of [this collection of
fonts](https://github.com/SteveAlexander/wingsfonts) in the `/priv/fonts/` folder.
