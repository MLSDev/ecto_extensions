defmodule EctoExtensions.Page do
  @moduledoc """
  Struct that represents pagination query result

  ## Fields

    * `page` - number
    * `page_size` - number
    * `total_pages` - number
    * `total_entries` - number
    * `entries` - list of entries
  """

  defstruct page: nil,
            page_size: nil,
            total_pages: nil,
            total_entries: nil,
            entries: []
end
