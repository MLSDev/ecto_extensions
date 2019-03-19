defmodule EctoExtensions.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecto_extensions,
      version: "0.0.2",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      docs: docs(),
      aliases: aliases(),
      name: "EctoExtensions",
      package: package(),
      description: description(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: preferred_cli_env(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  def application do
    [
      extra_applications: extra_applications(Mix.env())
    ]
  end

  defp extra_applications(:test), do: [:postgrex, :ecto_sql, :logger]
  defp extra_applications(_), do: [:logger]

  defp deps do
    [
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:ex_machina, "~> 2.3", only: :test},
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, "~> 0.14"}
    ]
  end

  defp docs do
    [
      extras: [
        "README.md": [filename: "readme", title: "Readme"],
        "CHANGELOG.md": [filename: "changelog", title: "Changelog"],
      ],
      main: "readme"
    ]
  end

  defp preferred_cli_env do
    [
      coveralls: :test,
      "coveralls.detail": :test,
      "coveralls.html": :test, 
      "coveralls.post": :test
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

  defp package do
    [
      maintainers: ["Anton Sakharov"],
      licenses: ["MIT"],
      links: %{"github" => "https://github.com/MLSDev/ecto_extensions"},
      files: [
        "lib/ecto_extensions.ex",
        "lib/ecto_extensions",
        "mix.exs",
        "README.md"
      ]
    ]
  end

  defp description do
    "Useful Ecto extensions: search, sort, paginate, validators"
  end
end
