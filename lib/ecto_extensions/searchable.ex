defmodule EctoExtensions.Searchable do
  @moduledoc """

  Makes your schema searchable.

  ## Usage

      defmodule Post do
        use Ecto.Schema
        use Ecto.Searchable, fields: [:title, :content]
        # ...
      end

      Post
      |> Repo.search(Post, %{search: "elixir"})
  """

  use Ecto.Schema

  import Ecto.Query
  import Ecto.Changeset
  import EctoExtensions.Helpers

  defmacro __using__(opts) do
    fields = Keyword.fetch!(opts, :fields)

    quote do
      def search_fields, do: unquote(fields)
    end
  end

  @primary_key false

  embedded_schema do
    field :search
  end

  @doc """
  Search implementation
  """
  def search(queryable, searchable, params) do
    %{search: search} = apply_params(searchable, params)

    queryable =
      searchable.search_fields()
      |> Enum.reduce(queryable, fn field, query ->
           from q in query, or_where: ilike(
             field(q, ^field),
             ^"%#{search}%"
           )
         end)
      |> distinct(true)

    queryable
  end

  @doc false
  def apply_params(_searchable, params) do
    params =
      params
      |> mapify()
      |> atomize_keys()

    %__MODULE__{}
    |> cast(params, [:search])
    |> sanitize()
    |> apply_changes()
    |> Map.from_struct()
  end

  @doc false
  def sanitize(changeset) do
    search = String.trim(changeset.changes[:search])
    put_change(changeset, :search, search)
  end
end
