defmodule EctoExtensions.Sortable do
  @moduledoc """

  Makes your schema sortable.

  ### Usage

      # in your app Repo module
      defmodule BlogApp.Repo do
        use Ecto.Repo,
          otp_app: :blog_app,
          adapter: Ecto.Adapters.Postgres

        use EctoExtensions # <- add this!

        # ...
      end

      # in your schema module
      defmodule BlogApp.Post do
        use Ecto.Schema
        use EctoExtensions.Sortable, fields: [:title, :published_at], # <- add this
                                     default: {:published_at, :desc}  # <- and this!

        schema "posts" do
          field :title
          field :content
          field :published_at, :utc_datetime
        end
      end

      # ... then, in your context or controller
      alias BlogApp.Repo
      alias BlogApp.Post

      # default sort
      Post
      |> Repo.sort(Post)

      # sort with params
      params = %{sort_by: :title, sort_order: :desc}

      from p in Post, where: ilike(p.content, "%elixir%")
      |> Repo.sort(Post, params)

  ### Testing

      defmodule BlogApp.PostTest do
        # ...

        test "sortable" do
          assert [:title, :published_at] = Post.sort_fields()
          assert {:published_at, :desc} = Post.default_sort()
        end
      end
  """

  use Ecto.Schema

  import Ecto.Query
  import Ecto.Changeset
  import EctoExtensions.Helpers

  defmacro __using__(opts) do
    sort_fields = Keyword.fetch!(opts, :fields)
    {field, order} = Keyword.fetch!(opts, :default)

    quote do
      def sort_fields, do: unquote(sort_fields)
      def default_sort, do: {unquote(field), unquote(order)}
    end
  end

  @allowed_sort_orders [:asc, :desc]

  @primary_key false

  embedded_schema do
    field :sort_by, :string
    field :sort_order, :string
  end

  @doc """
  Sorting implementation
  """
  def sort(queryable, sortable, params) do
    #params = Enum.into(params, %{})
    %{sort_by: field, sort_order: order} = __MODULE__.apply_params(sortable, params)
    order_by(queryable, {^order, ^field})
  end

  @doc false
  def apply_params(sortable, params) do
    params =
      params
      |> mapify()
      |> atomize_keys()
      |> stringify_values()

    {field, order} = default_sort_as_strings(sortable)

    %__MODULE__{sort_by: field, sort_order: order}
    |> cast(params, [:sort_by, :sort_order])
    |> verify_sort_by(sortable)
    |> verify_sort_order(sortable)
    |> apply_changes()
    |> Map.from_struct()
    |> atomize_values()
  end

  defp verify_sort_by(%Ecto.Changeset{changes: %{sort_by: sort_by}} = changeset, sortable) do
    if String.to_atom(sort_by) in sortable.sort_fields() do
      changeset
    else
      fallback_to_default(changeset, sortable)
    end
  end
  defp verify_sort_by(changeset, _sortable), do: changeset

  defp verify_sort_order(%Ecto.Changeset{changes: %{sort_order: sort_order}} = changeset, sortable) do
    if String.to_atom(sort_order) in @allowed_sort_orders do
      changeset
    else
      fallback_to_default(changeset, sortable)
    end
  end
  defp verify_sort_order(changeset, _sortable), do: changeset

  defp fallback_to_default(changeset, sortable) do
    {field, order} = default_sort_as_strings(sortable)

    changeset
    |> put_change(:sort_by, field)
    |> put_change(:sort_order, order)
  end

  defp default_sort_as_strings(sortable) do
    {field, order} = sortable.default_sort()
    {to_string(field), to_string(order)}
  end
end
