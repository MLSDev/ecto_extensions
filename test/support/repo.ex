defmodule EctoExtensions.Repo do
  use Ecto.Repo,
    otp_app: :ecto_extensions,
    adapter: Ecto.Adapters.Postgres

  use EctoExtensions
end
