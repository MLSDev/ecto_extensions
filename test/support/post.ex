defmodule EctoExtensions.Post do
  @moduledoc false

  use Ecto.Schema
  use EctoExtensions.Sortable, fields: [:title, :published_at],
                               default: {:published_at, :desc}

  use EctoExtensions.Searchable, fields: [:title, :content]

  schema "posts" do
    field :title
    field :content
    field :published_at, :utc_datetime
  end
end
