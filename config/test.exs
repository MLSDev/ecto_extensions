use Mix.Config

config :ecto_extensions, EctoExtensions.Repo,
  username: System.get_env("ECTO_EXTENSIONS_DB_USERNAME") || "postgres",
  password: System.get_env("ECTO_EXTENSIONS_DB_PASSWORD") || "postgres",
  database: "ecto_extensions_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :ecto_extensions,
  ecto_repos: [EctoExtensions.Repo]
