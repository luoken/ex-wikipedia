defmodule ExWikipedia.MixProject do
  use Mix.Project

  @version "0.2.0"

  def project do
    [
      app: :ex_wikipedia,
      version: @version,
      elixir: "~> 1.13.4",
      package: package(),
      description: "Elixir wrapper for Wikipedia's API.",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger, :httpoison]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:excoveralls, "~> 0.14.3", only: :test},
      {:floki, "~> 0.32.1", only: [:dev, :test], optional: true},
      {:httpoison, "~> 1.8", optional: true},
      {:jason, "~> 1.2", optional: true},
      {:mox, "~> 1.0.0", only: [:test]}
    ]
  end

  defp package do
    [
      maintainers: ["Ken Luo"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/luoken/ex-wikipedia"}
    ]
  end
end
