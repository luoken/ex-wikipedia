defmodule ExWikipedia.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_wikipedia,
      version: "0.1.0",
      elixir: "~> 1.11.4",
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

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :httpoison]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:httpoison, "~> 1.8", optional: true},
      {:jason, "~> 1.2", optional: true},
      {:floki, "~> 0.31.0"},
      {:mox, "~> 1.0.0"},
      {:excoveralls, "~> 0.14.3", only: :test},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false}
    ]
  end
end
