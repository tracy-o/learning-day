defmodule Belfrage.ResponseTransformers.CacheDirective do
  @moduledoc """
  - Parses the Cache-Control header, and saves result to `struct.response.cache_directive`
  - Removes the Cache-Control response header, so it is not stored in the cache
  """

  alias Belfrage.{CacheControlParser, Struct}
  alias Belfrage.Behaviours.ResponseTransformer
  @behaviour ResponseTransformer

  @impl true
  def call(struct = %Struct{response: %Struct.Response{headers: %{"cache-control" => cache_control}}}) do
    response_headers = Map.delete(struct.response.headers, "cache-control")

    cache_directive = CacheControlParser.parse(cache_control)
    cache_directive = %{cache_directive | max_age: dial_multiply(cache_directive[:max_age])}

    struct
    |> Struct.add(:response, %{cache_directive: cache_directive, headers: response_headers})
  end

  @impl true
  def call(struct), do: struct

  defp dial_multiply(max_age) do
    Belfrage.Dials.state()["ttl_multiplier"]
    |> Kernel.||("1")
    |> Integer.parse()
    |> elem(0)
    |> Kernel.*(max_age)
  end
end
