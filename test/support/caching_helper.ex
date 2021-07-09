defmodule Belfrage.Test.CachingHelper do
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
  def clear_cache(name \\ :cache) do
    Cachex.clear(name)
  end

  @doc """
  Puts the struct's response into the cache under the `request_hash` of the struct's request.
  """
  def put_into_cache(struct = %Belfrage.Struct{}) do
    request_hash = struct.request.request_hash || Belfrage.RequestHash.generate(struct).request.request_hash
    put_into_cache(request_hash, struct.response)
  end

  @doc """
  Puts the response into the cache under the passed key.
  """
  def put_into_cache(key, response = %Belfrage.Struct.Response{}) do
    Cachex.put(
      :cache,
      key,
      Map.put(response, :cache_last_updated, response.cache_last_updated || Belfrage.Timer.now_ms())
    )
  end
end