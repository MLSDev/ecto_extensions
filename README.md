# Ecto Extensions

[![Hex Version](http://img.shields.io/hexpm/v/ecto_extensions.svg?style=flat)](https://hex.pm/packages/ecto_extensions)
[![Hex docs](http://img.shields.io/badge/hex.pm-docs-green.svg?style=flat)](https://hexdocs.pm/ecto_extensions)
[![Build Status](https://travis-ci.org/MLSDev/ecto_extensions.svg?branch=master)](https://travis-ci.org/MLSDev/ecto_extensions)
[![Coverage Status](https://coveralls.io/repos/github/MLSDev/ecto_extensions/badge.svg?branch=master)](https://coveralls.io/github/MLSDev/ecto_extensions)

Useful Ecto extensions:

  * `Sortable`
  * `Pageable`
  * `Searchable`
  * `Validators`

Documentation: [https://hexdocs.pm/ecto_extensions](https://hexdocs.pm/ecto_extensions)

**Please note:** this project is a work-in-progress. Breaking changes may occur.


## Install

Add EctoExtensions to `mix.exs`:

```elixir
[{:ecto_extensions, "~> 0.0.2"}]
```


## Example usage

### Search, sort and paginate

* `Repo` module:

```elixir
defmodule BlogApp.Repo do
  # ...
  use EctoExtensions # <- add this!
end
```

* `Schema` module:

```elixir
defmodule BlogApp.Post do
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
```

* `Context` module:

```elixir
defmodule BlogApp.Posts do
  @doc """

  ## Params
  * :search - search query string
  * :sort_by - field to sort by
  * :sort_order - :asc or :desc
  * :page - integer
  * :page_size - integer

  """
  def list_posts(params) do
    Post
    |> Repo.search(Post, params)
    |> Repo.sort(Post, params)
    |> Repo.paginate(params)
  end
end
```

* `Controller` and `View`:

```elixir
defmodule BlogAppWeb.PostController do
  def index(conn, params) do
    page = Posts.list_posts(params)
    render(conn, "index.json", %{page: page})
  end
end

defmodule BlogAppWeb.PostView do
  def render("index.json", %{page: page}) do
    %{
      page: page.page,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries,
      posts: render_many(page.entries, PostView, "post.json")
    }
  end

  def render("post.json", %{post: post}) do
    # ...
  end
end
```


### Validators

* `Schema` module:

```elixir
defmodule BlogApp.User do
  use Ecto.Schema

  import EctoExtensions.Validators # <- add this!

  schema "users" do
    field :email
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:email])
    |> validate_email()
  end
end
```


## Contributing

* Fork it
* `mix deps.get`
* `mix ecto.reset`
* Make your changes
* `mix test`
* Create a pull-request


## License

`EctoExtensions` is released under the MIT license. See [LICENSE](LICENSE) file for details.


## About MLSDev

[<img src="https://github.com/MLSDev/development-standards/raw/master/mlsdev-logo.png" alt="MLSDev.com">][mlsdev]

`EctoExtensions` package is maintained by [MLSDev, Inc.][mlsdev] We specialize in providing all-in-one solution in mobile and web development. Our team follows Lean principles and works according to agile methodologies to deliver the best results reducing the budget for development and its timeline.

Find out more [here][mlsdev] and don't hesitate to [contact us][contact]!

[mlsdev]: https://mlsdev.com
[contact]: https://mlsdev.com/contact-us
