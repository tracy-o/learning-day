defmodule Belfrage.Cache.Store do
  alias Belfrage.Cache.MultiStrategy
  alias Belfrage.Cache.Local
  alias Belfrage.Metrics

  def store(envelope) do
    cond do
      store_in_local_and_distributed_cache?(envelope) ->
        Metrics.latency_span(:cache_response, fn ->
          MultiStrategy.store(envelope)
        end)

        envelope

      store_in_local_cache?(envelope) ->
        Metrics.latency_span(:cache_response, fn ->
          Local.store(envelope, make_stale: true)
        end)

        envelope

      true ->
        envelope
    end
  end

  defp store_in_local_and_distributed_cache?(envelope) do
    is_cacheable?(envelope) and not is_response_fallback?(envelope)
  end

  defp store_in_local_cache?(envelope) do
    is_cacheable?(envelope) and is_response_fallback?(envelope) and
      envelope.response.cache_type == :distributed
  end

  defp is_cacheable?(envelope) do
    is_caching_enabled?(envelope) and is_successful_response?(envelope) and is_get_request?(envelope) and
      is_public_cacheable_response?(envelope)
  end

  defp is_public_cacheable_response?(envelope) do
    case envelope.response.cache_directive do
      %Belfrage.CacheControl{cacheability: "public", max_age: max_age} when is_integer(max_age) -> true
      _ -> false
    end
  end

  defp is_successful_response?(envelope) do
    envelope.response.http_status == 200
  end

  defp is_get_request?(envelope) do
    envelope.request.method == "GET"
  end

  defp is_caching_enabled?(envelope) do
    envelope.private.caching_enabled
  end

  defp is_response_fallback?(envelope) do
    envelope.response.fallback
  end
end
