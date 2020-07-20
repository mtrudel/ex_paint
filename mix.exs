defmodule ExPaint.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_paint,
      version: "0.2.1",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      source_url: "https://github.com/mtrudel/ex_paint"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end

  defp description do
    "A simple 2D rasterizing library"
  end

  defp package() do
    [
      files: ["lib", "test", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Mat Trudel"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/mtrudel/ex_paint"}
    ]
  end
end
