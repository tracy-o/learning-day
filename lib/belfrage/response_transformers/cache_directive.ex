defmodule Belfrage.ResponseTransformers.CacheDirective do
  @moduledoc """
  - Parses the Cache-Control header, and saves result to `struct.response.cache_directive`
  - Removes the Cache-Control response header, so it is not stored in the cache
  """

  alias Belfrage.{CacheControl, Struct}
  alias Belfrage.Behaviours.ResponseTransformer
  @behaviour ResponseTransformer

  @impl true
  def call(struct = %Struct{response: %Struct.Response{headers: %{"cache-control" => cache_control}}}) do
    response_headers = Map.delete(struct.response.headers, "cache-control")

    struct
    |> Struct.add(:response, %{
      cache_directive: cache_directive(CacheControl.Parser.parse(cache_control), Belfrage.Dials.ttl_multiplier()),
      headers: response_headers
    })
  end

  @impl true
  def call(struct), do: struct

  defp dial_multiply(nil, _ttl_multiplier), do: nil

  defp dial_multiply(max_age, ttl_multiplier) do
    max_age
    |> Kernel.*(ttl_multiplier)
    |> to_integer()
  end

  defp to_integer(max_age) when is_float(max_age), do: round(max_age)
  defp to_integer(max_age), do: max_age

  defp cache_directive(cache_directive = %Belfrage.CacheControl{max_age: max_age}, ttl_multiplier)
       when ttl_multiplier == 0 do
    %Belfrage.CacheControl{cache_directive | cacheability: "private", max_age: dial_multiply(max_age, ttl_multiplier)}
  end

  defp cache_directive(cache_directive = %Belfrage.CacheControl{max_age: max_age}, ttl_multiplier) do
    %Belfrage.CacheControl{cache_directive | max_age: dial_multiply(max_age, ttl_multiplier)}
  end
end
