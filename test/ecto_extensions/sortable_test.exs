defmodule EctoExtensions.SortableTest do
  use EctoExtensions.TestCase

  alias EctoExtensions.Sortable

  defmodule TestSchema do
    use Ecto.Schema
    use Sortable, fields: [:title, :published_at],
                  default: {:published_at, :desc}

    embedded_schema do
      field :title
      field :content
      field :published_at, :utc_datetime
    end
  end

  describe "sort(queryable, sortable, params)" do
    test "returns query" do
      query =
        TestSchema
        |> Sortable.sort(TestSchema, %{})

      assert %Ecto.Query{} = query
    end
  end

  describe "using Sortable" do
    test "adds methods to schema" do
      assert [:title, :published_at] = TestSchema.sort_fields()
      assert {:published_at, :desc} = TestSchema.default_sort()
    end
  end

  describe "apply_params(sortable, params)" do
    test "casts params" do
      params = %{"sort_by" => "title", "sort_order" => "desc"}

      assert %{
        sort_by: :title,
        sort_order: :desc
      } = Sortable.apply_params(TestSchema, params)
    end

    test "accepts map with atoms as params" do
      params = %{sort_by: :title, sort_order: :desc}

      assert %{
        sort_by: :title,
        sort_order: :desc
      } = Sortable.apply_params(TestSchema, params)
    end

    test "accepts keyword list with atoms as params" do
      params = [sort_by: :title, sort_order: :desc]

      assert %{
        sort_by: :title,
        sort_order: :desc
      } = Sortable.apply_params(TestSchema, params)
    end

    test "validates params and falls back to defaults" do
      params = %{sort_by: :title, sort_order: :asc}

      assert %{
        sort_by: :title,
        sort_order: :asc
      } = Sortable.apply_params(TestSchema, params)


      params = %{sort_by: :content, sort_order: :desc}

      assert %{
        sort_by: :published_at,
        sort_order: :desc
      } = Sortable.apply_params(TestSchema, params)

      params = %{sort_by: :published_at, sort_order: :descending}

      assert %{
        sort_by: :published_at,
        sort_order: :desc
      } = Sortable.apply_params(TestSchema, params)
    end
  end
end
