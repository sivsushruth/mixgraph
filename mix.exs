defmodule Mixgraph.Mixfile do
  use Mix.Project

  def project do
    [app: :mixgraph,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: [main_module: Mixgraph],
     description: description,
     package: package,
     deps: deps]
  end
  
  defp package do
    [
      maintainers: ["Sushruth S"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/sivsushruth/mixgraph"}
    ]
  end

  defp description do
    """
    Create an interactive dependency graph for any hex package published in hex.pm
    """
  end

  def application do
    [applications: [:logger, :httpotion, :json]]
  end

  defp deps do
    [{:httpotion, "~> 2.2.0"}, {:json, "~> 0.3.0"}]
  end
end
