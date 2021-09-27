defmodule Belfrage.Test.CachingHelper do
  alias Belfrage.{Struct, CacheControl, Timer}
  alias Belfrage.Struct.Response

  @cache_name :cache

  @doc """
  Using this will ensure that the caching key is unique to the test and prevent
  clashes with other tests
  """
  defmacro cache_key(key) do
    quote do
      "#{__MODULE__}-#{unquote(key)}"
    end
  end

  defmacro unique_cache_key() do
    quote do
      UUID.uuid4(:hex) |> cache_key()
    end
  end

  @doc """
  This clears the entire cache, so can affect other tests if called from an
  async test. Consider using unique cache keys instead if possible.
  """
  def clear_cache(_ \\ nil) do
    Cachex.clear(@cache_name)
    :ok
  end

  @doc """
  Puts the struct's response into the cache under the `request_hash` of the struct's request.
  """
  def put_into_cache(struct = %Struct{}) do
    request_hash = struct.request.request_hash || Belfrage.RequestHash.generate(struct)
    put_into_cache(request_hash, struct.response)
  end

  @doc """
  Puts the response into the cache under the passed key.
  """
  def put_into_cache(key, response = %Response{}) do
    response =
      response
      |> Map.put(:cache_last_updated, response.cache_last_updated || Timer.now_ms())
      |> Map.put(:cache_directive, default_cache_directive(response.cache_directive))

    {:ok, _} = Cachex.put(@cache_name, key, response)

    response
  end

  defp default_cache_directive(cache_directive) do
    if cache_directive == %CacheControl{cacheability: "private"} do
      %CacheControl{cacheability: "public", max_age: 60}
    else
      cache_directive
    end
  end

  @doc """
  Updates the parameters of the response cached under the passed key to make it stale
  """
  def make_cached_reponse_stale(key) do
    {:ok, response} = Cachex.get(@cache_name, key)
    put_into_cache(key, %Response{response | cache_last_updated: Timer.now_ms() - 61_000})
  end

  @doc """
  Puts the struct's response into the cache and marks the cached response as stale.
  """
  def put_into_cache_as_stale(struct = %Struct{}) do
    request_hash = struct.request.request_hash || Belfrage.RequestHash.generate(struct)
    put_into_cache(request_hash, struct.response)
    make_cached_reponse_stale(request_hash)
  end
end
