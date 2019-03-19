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

    if search && byte_size(search) > 0 do
      do_search(queryable, searchable, search)
    else
      queryable
    end
  end

  defp do_search(queryable, searchable, search) do
    searchable.search_fields()
    |> Enum.reduce(queryable, fn field, query ->
         from q in query, or_where: ilike(
           field(q, ^field),
           ^"%#{search}%"
         )
       end)
    |> distinct(true)
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
  def sanitize(%Ecto.Changeset{changes: %{search: search}} = changeset) do
    put_change(changeset, :search, String.trim(search))
  end
  def sanitize(changeset), do: changeset
end
