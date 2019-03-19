defmodule EctoExtensions.SearchableTest do
  use EctoExtensions.TestCase

  alias EctoExtensions.Searchable

  defmodule TestSchema do
    use Ecto.Schema
    use Searchable, fields: [:title, :content]

    embedded_schema do
      field :title
      field :content
      field :published_at, :utc_datetime
    end
  end

  describe "search(queryable, searchable, params)" do
    test "returns query" do
      query =
        TestSchema
        |> Searchable.search(TestSchema, %{search: "elixir"})

      assert %Ecto.Query{} = query
    end

    test "returns queryable on empty search string" do
      query =
        TestSchema
        |> Searchable.search(TestSchema, %{})

      assert TestSchema == query
    end
  end

  describe "using Searchable" do
    test "adds methods to schema" do
      assert [:title, :content] = TestSchema.search_fields()
    end
  end

  describe "apply_params(sortable, params)" do
    test "casts params" do
      params = %{"search" => "elixir"}

      assert %{
        search: "elixir"
      } = Searchable.apply_params(TestSchema, params)
    end

    test "accepts keyword list with atoms as params" do
      params = [search: "elixir"]

      assert %{
        search: "elixir"
      } = Searchable.apply_params(TestSchema, params)
    end

    test "trims search string" do
      params = %{search: " elixir  "}

      assert %{
        search: "elixir"
      } = Searchable.apply_params(TestSchema, params)
    end
  end
end
