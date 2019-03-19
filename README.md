# Ecto Extensions

[![Hex Version](http://img.shields.io/hexpm/v/ecto_extensions.svg?style=flat)](https://hex.pm/packages/ecto_extensions)
[![Hex docs](http://img.shields.io/badge/hex.pm-docs-green.svg?style=flat)](https://hexdocs.pm/ecto_extensions)
[![Build Status](https://travis-ci.org/MLSDev/ecto_extensions.svg?branch=master)](https://travis-ci.org/MLSDev/ecto_extensions)
[![Coverage Status](https://coveralls.io/repos/github/MLSDev/ecto_extensions/badge.svg?branch=master)](https://coveralls.io/github/MLSDev/ecto_extensions?branch=master)

Useful Ecto extensions: search, sort, paginate, validators.

Documentation: [https://hexdocs.pm/ecto_extensions](https://hexdocs.pm/ecto_extensions)

**Please note:** this project is a work-in-progress. Breaking changes may occur.


## Install

Add EctoExtensions to `mix.exs`:

```elixir
[{:ecto_extensions, "~> 0.0.1"}]
```


## Usage

```elixir
defmodule MyApp.Repo do
  # ...
  use EctoExtensions # <- add this!
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
