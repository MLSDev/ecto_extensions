defmodule EctoExtensions.ValidatorsTest do
  use EctoExtensions.TestCase

  import Ecto.Changeset
  alias EctoExtensions.Validators

  defmodule TestSchema do
    use Ecto.Schema

    embedded_schema do
      field :email
      field :work_email
    end

    def changeset(struct, params \\ %{}) do
      cast(struct, params, [:email, :work_email])
    end
  end

  def schema_params(params \\ []) do
    Map.merge(
      %{
        email: "john.doe@gmail.com",
        work_email: "john.doe@company.com"
      },
      Enum.into(params, %{})
    )
  end

  def test_changeset(params) do
    TestSchema.changeset(%TestSchema{}, schema_params(params))
  end

  describe "validate_email(changeset, field)" do
    test "validates email format"do
      changeset =
        test_changeset(work_email: "invalid")
        |> Validators.validate_email(:work_email)

      assert {
               :work_email,
               {"has invalid format", [validation: :format]}
             } in changeset.errors
    end

    test "defaults field to :email" do
      changeset =
        test_changeset(email: "invalid")
        |> Validators.validate_email()

      assert {
               :email,
               {"has invalid format", [validation: :format]}
             } in changeset.errors
    end
  end
end
