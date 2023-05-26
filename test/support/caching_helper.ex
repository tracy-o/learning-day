defmodule Belfrage.Test.CachingHelper do
  alias Belfrage.{Envelope, CacheControl, Timer}
  alias Belfrage.Envelope.Response
  alias Plug.Conn

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

  @doc """
  Using this will ensure that the caching key is unique to the test and prevent
  clashes with other tests. But will also ensure the key is in the uuid format.
  """
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
  This clears the entire metadata cache, so can affect other tests if called from an
  async test. Can be called from setup/1 like:

      setup :clear_preflight_metadata_cache
  """
  def clear_preflight_metadata_cache(_context) do
    clear_preflight_metadata_cache()
    :ok
  end

  def clear_preflight_metadata_cache() do
    :ets.delete_all_objects(:preflight_metadata_cache)
  end

  @doc """
  Puts the envelope's response into the cache under the `request_hash` of the envelope's request.
  """
  def put_into_cache(envelope = %Envelope{}) do
    request_hash = envelope.request.request_hash || Belfrage.RequestHash.generate(envelope)
    put_into_cache(request_hash, envelope.response)
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

  @doc """
  Puts the envelope's response into the cache and marks the cached response as stale.
  """
  def put_into_cache_as_stale(envelope = %Envelope{}) do
    request_hash = envelope.request.request_hash || Belfrage.RequestHash.generate(envelope)
    put_into_cache(request_hash, envelope.response)
    make_cached_response_stale(request_hash)
  end

  @doc """
  Makes the cached response stale. Accepts either:

  * `%Plug.Conn{}` - marks the response received while processing it stale
  * key - marks the response stored under the passed key as stale
  """
  def make_cached_response_stale(conn = %Conn{}) do
    conn
    |> BelfrageWeb.EnvelopeAdapter.Request.adapt()
    |> Belfrage.RequestHash.generate()
    |> make_cached_response_stale()
  end

  def make_cached_response_stale(key) do
    {:ok, response} = Cachex.get(@cache_name, key)
    put_into_cache(key, %Response{response | cache_last_updated: Timer.now_ms() - 61_000})
  end

  defp default_cache_directive(cache_directive) do
    if cache_directive == %CacheControl{cacheability: "private"} do
      %CacheControl{cacheability: "public", max_age: 60}
    else
      cache_directive
    end
  end
end
