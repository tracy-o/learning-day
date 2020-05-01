defmodule Belfrage.CacheControlParser do
  defmodule FindValue do
    def find(["stale-if-error=" <> value | _rest], key: :stale_if_error, default: _) do
      {num, _string} = Integer.parse(value)
      num
    end

    def find(["stale-while-revalidate=" <> value | _rest], key: :stale_while_revalidate, default: _) do
      {num, _string} = Integer.parse(value)
      num
    end

    def find(["max-age=" <> value | _rest], key: :max_age, default: _) do
      {num, _string} = Integer.parse(value)
      num
    end

    def find(header_values, opts) when length(header_values) > 0 do
      header_values
      |> List.delete_at(0)
      |> find(opts)
    end

    def find(_, key: _, default: default), do: default
  end

  def parse(cache_control_header) do
    cache_control_header = standardise_cache_control_header(cache_control_header)
    max_age = parse_max_age(cache_control_header)

    %{
      cacheability: parse_cacheability(max_age, cache_control_header),
      max_age: max_age,
      stale_if_error: parse_stale_if_error(cache_control_header),
      stale_while_revalidate: parse_stale_while_revalidate(cache_control_header)
    }
  end

  def parse_cacheability(max_age, cache_control_header) when max_age > 0 do
    if Enum.member?(cache_control_header, "private"), do: "private", else: "public"
  end

  def parse_cacheability(_max_age, cache_control_header) do
    if Enum.member?(cache_control_header, "public"), do: "public", else: "private"
  end

  def parse_max_age(cache_control_header) do
    cache_control_header
    |> FindValue.find(key: :max_age, default: 0)
  end

  def parse_stale_while_revalidate(cache_control_header) do
    cache_control_header
    |> FindValue.find(key: :stale_while_revalidate, default: 0)
  end

  def parse_stale_if_error(cache_control_header) do
    cache_control_header
    |> FindValue.find(key: :stale_if_error, default: 0)
  end

  defp standardise_cache_control_header(cache_control_header) do
    cache_control_header
    |> String.downcase()
    |> String.replace([~s('), ~s("), ~s(,)], "")
    |> String.split(" ")
  end
end
