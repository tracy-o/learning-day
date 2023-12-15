defmodule LearningDay.MixProject do
  use Mix.Project

  def project do
    [
      app: :learning_day,
      version: "0.1.0",
      elixir: "~> 1.15.1",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:levenshtein, "~> 0.3.0"},
      {:randex, "~> 0.4.0"},
      {:plug_cowboy, "~> 2.6"},
      {:httpoison, "~> 2.0"},
      {:poison, "~> 5.0"},
      {:solid, "~> 0.15.2"}
    ]
  end
end
