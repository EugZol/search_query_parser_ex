defmodule SearchQueryParserEx.Mixfile do
  use Mix.Project

  def project do
    [
      app: :search_query_parser_ex,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
    ]
  end

  defp package do
    %{
      maintainers: ["Eugene Zolotarev"],
      licenses: ["MIT"],
      files: ["lib", "src/*.yrl", "mix.exs", "README.md"],
      links: %{
        "GitHub" => "https://github.com/EugZol/search_parser_ex"
      }
    }
  end
end
