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
image = ExPaint.create(256, 64)
font = Font.load("Helvetica22")

ExPaint.clear(image, Color.black())

ExPaint.text(image, {10, 10}, label_font, "This is text", Color.white())

ExPaint.rectangle(image, {10, 10}, {40,20}, Color.white())

# Write to a png
File.write("foo.png", ExPaint.png(image))

# If you're in iTerm, display inline
ExPaint.inline(image)

# If you're pairing with https://github.com/mtrudel/ssd1322
SSD1322.draw(session, ExPaint.render(image, :four_bit_greyscale))
```

## Credits

For ease of installation, this package includes the contents of [this collection of
fonts](https://github.com/SteveAlexander/wingsfonts) in the `/priv/fonts/` folder.

## Installation

This package can be installed by adding `ex_paint` and 'egd' to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_paint, "~> 0.1.0"},
    {:egd, github: "erlang/egd"}
  ]
end
```

Docs can be found at [https://hexdocs.pm/ex_paint](https://hexdocs.pm/ex_paint).

