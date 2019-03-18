defmodule EctoExtensions.Validators do
  @moduledoc """
  Custom validators
  """

  import Ecto.Changeset

  @doc """
  Validates email format
  """
  @email_regex ~r/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  def validate_email(%Ecto.Changeset{} = changeset, field \\ :email) when is_atom(field) do
    validate_format(changeset, field, @email_regex)
  end
end
