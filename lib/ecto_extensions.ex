defmodule EctoExtensions do
  @moduledoc """
  Useful Ecto stuff:

    * [sorting](`EctoExtensions.Sortable`)
    * [pagination](`EctoExtensions.Pageable`)
    * searching
    * validations

  ## Usage

      defmodule MyApp.Repo do
        # ...
        use EctoExtensions # <- add this!
      end
  """

  @default_page_size 10
  @max_page_size 100

  defmacro __using__(opts) do
    default_page_size = Keyword.get(opts, :default_page_size, @default_page_size)
    max_page_size = Keyword.get(opts, :max_page_size, @max_page_size)

    quote do
      def default_page_size, do: unquote(default_page_size)
      def max_page_size, do: unquote(max_page_size)

      @doc """
      Adds search query to given `queryable`.

      ## Options

        * `:search` - search string
      """
      def search(queryable, searchable, params) do
        EctoExtensions.Searchable.search(queryable, searchable, params)
      end

      @doc """
      Adds sort query to given `queryable`.

      ## Options

        * `:sort_by` - sort field name atom. Example: `:title`
        * `:sort_order` - `:asc` or `:desc`
      """
      def sort(queryable, sortable, params \\ %{}) do
        EctoExtensions.Sortable.sort(queryable, sortable, params)
      end

      @doc """
      Paginates `queryable`.

      ## Options

        * `page`
        * `page_size`

      ## Example
          iex> Repo.paginate(User, %{page: 1, per_page: 25})
          [
            total_entries: 15,
            page: 1,
            page_size: 25,
            page_entries: 15,
            total_pages: 1,
            offset: 0,
            limit: 25,
            entries: [%User{}, ...]
          ]
      """
      def paginate(queryable, params \\ %{}) do
        EctoExtensions.Pageable.paginate(queryable, __MODULE__, params)
      end
    end
  end
end
