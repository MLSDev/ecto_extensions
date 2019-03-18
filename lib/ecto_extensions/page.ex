defmodule EctoExtensions.Page do
  @moduledoc """
  Struct that represents pagination query result
  """

  defstruct page: nil,
            page_size: nil,
            total_pages: nil,
            total_entries: nil,
            entries: []
end
