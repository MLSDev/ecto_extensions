defmodule EctoExtensions.TestCase do
  use ExUnit.CaseTemplate

  using opts do
    quote do
      use ExUnit.Case, unquote(opts)
      import Ecto.Query
    end
  end

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(EctoExtensions.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(EctoExtensions.Repo, {:shared, self()})
  end
end

EctoExtensions.Repo.start_link()

{:ok, _} = Application.ensure_all_started(:ex_machina)

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(EctoExtensions.Repo, :manual)
