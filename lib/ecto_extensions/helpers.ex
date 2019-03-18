defmodule EctoExtensions.Helpers do
  @moduledoc false

  @doc false
  def mapify(map_or_keyword)

  def mapify(map) when is_map(map), do: map
  def mapify(keyword) when is_list(keyword), do: Enum.into(keyword, %{})

  @doc false
  def stringify_values(%{} = map) do
    Enum.into(map, %{}, fn {k, v} -> {k, to_string(v)} end)
  end

  @doc false
  def atomize_values(%{} = map) do
    Enum.into(map, %{}, fn {k, v} -> if is_atom(v), do: {k, v}, else: {k, String.to_atom(v)} end)
  end

  @doc false
  def atomize_keys(%{} = map) do
    Enum.into(map, %{}, fn {k, v} -> if is_atom(k), do: {k, v}, else: {String.to_atom(k), v} end)
  end
end
