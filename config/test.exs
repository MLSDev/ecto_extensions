use Mix.Config

config :ecto_extensions, EctoExtensions.Repo,
  username: "postgres",
  password: "postgres",
  database: "ecto_extensions_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :ecto_extensions,
  ecto_repos: [EctoExtensions.Repo]
