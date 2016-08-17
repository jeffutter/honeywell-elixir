defmodule Honeywell.Mixfile do
  use Mix.Project

  def project do
    [app: :honeywell,
     version: "0.1.1",
     elixir: "~> 1.3",
     name: "Honeywell Api Client",
     source_url: "https://github.com/jeffutter/honeywell-elixir.ex",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     docs: [
			 extras: ["README.md"]
     ],
		 package: package,
     deps: deps,
		 description: description]
  end

  def application do
    [applications: [:logger, :oauth2, :poison],
     mod: {Honeywell, []}]
  end

  defp description do
    """
    Client library for the Honeywell Round and Water Leak & Freeze Detector APIs.
    """
	end

  defp deps do
    [
      {:httpoison, "~> 0.9.0"},
      {:oauth2, "~> 0.7.0"},
      {:poison, "~> 2.2.0"},
      {:credo, "~> 0.4", only: [:dev, :test]},
			{:ex_doc, "~> 0.12", only: :dev},
			{:inch_ex, only: :docs},
      {:exvcr, "~> 0.7", only: :test}
    ]
  end

  def package do
    [
			name: :honeywell,
			maintainers: ["Jeffery Utter"],
			licenses: ["MIT"],
			links: %{"Github" => "https://github.com/jeffutter/honeywell-elixir"},
    ]
	end
end
