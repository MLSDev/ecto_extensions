defmodule EctoExtensions.Pageable do
  @moduledoc """

  Makes your repo pageable.

  ### Usage

      defmodule Post do
        use Ecto.Schema
        # ...
      end

      Post
      |> Repo.paginate(Post, %{page: 2, page_size: 25})

  ### Options

    * `:default_page_size` - defaults to 10
    * `:min_page_size` - defaults to 1
    * `:max_page_size` - defaults to 100
  """

  use Ecto.Schema

  import Ecto.Query
  import Ecto.Changeset
  import EctoExtensions.Helpers

  @primary_key false

  embedded_schema do
    field :page, :integer
    field :page_size, :integer
    field :limit, :integer
    field :offset, :integer
  end

  @doc """
  Pagination implementation
  """
  def paginate(queryable, repo, params) do
    params = apply_params(repo, params)

    %{page_size: limit, page: page} = params
    offset = (page - 1) * limit

    total_entries = calculate_total_entries(queryable, repo)

    limit = validate_limit(limit, repo)
    offset = validate_offset(offset, total_entries)

    entries =
      queryable
      |> offset(^offset)
      |> limit(^limit)
      |> repo.all()

    %{
      total_entries: total_entries,
      page: div(offset, limit) + 1,
      page_size: limit,
      page_entries: length(entries),
      total_pages: calculate_total_pages(total_entries, limit),
      offset: offset,
      limit: limit,
      entries: entries
    }
  end

  @doc false
  def apply_params(repo, params) do
    params =
      params
      |> mapify()
      |> atomize_keys()

    %__MODULE__{page: 1, page_size: repo.default_page_size()}
    |> cast(params, [:page, :page_size])
    |> apply_changes()
    |> Map.from_struct()
  end

  defp validate_limit(limit, repo) do
    cond do
      limit < 1 -> repo.default_page_size()
      limit > repo.max_page_size() -> repo.default_page_size()
      true -> limit
    end
  end

  defp validate_offset(offset, total_entries) do
    cond do
      offset < 0 -> 0
      offset >= total_entries -> 0
      true -> offset
    end
  end

  defp calculate_total_entries(queryable, repo) do
    queryable
    |> total_entries_query()
    |> repo.one()
  end

  defp total_entries_query(queryable) do
    queryable
    |> exclude(:preload)
    |> exclude(:order_by)
    |> exclude(:select)
    |> select(count("*"))
  end

  defp calculate_total_pages(total_entries, limit) do
    Float.ceil(total_entries / limit) |> trunc()
  end
end
