defmodule Belfrage.CacheControl.Parser do
  alias Belfrage.CacheControl.FindValue

  def parse(cache_control_header) do
    cache_control_header = standardise_cache_control_header(cache_control_header)
    max_age = parse_max_age(cache_control_header)

    %Belfrage.CacheControl{
      cacheability: parse_cacheability(max_age, cache_control_header),
      max_age: max_age,
      stale_if_error: parse_stale_if_error(cache_control_header),
      stale_while_revalidate: parse_stale_while_revalidate(cache_control_header)
    }
  end

  def parse_cacheability(max_age, cache_control_header) do
    cond do
      "public" in cache_control_header -> "public"
      "private" in cache_control_header -> "private"
      not is_nil(max_age) -> "public"
      true -> "private"
    end
  end

  def parse_max_age(cache_control_header) do
    cache_control_header
    |> FindValue.find(key: :max_age, default: nil)
  end

  def parse_stale_while_revalidate(cache_control_header) do
    cache_control_header
    |> FindValue.find(key: :stale_while_revalidate, default: 30)
  end

  def parse_stale_if_error(cache_control_header) do
    cache_control_header
    |> FindValue.find(key: :stale_if_error, default: 90)
  end

  defp standardise_cache_control_header(cache_control_header) do
    cache_control_header
    |> String.downcase()
    |> String.replace([~s('), ~s("), ~s(,)], "")
    |> String.split(" ")
  end
end
