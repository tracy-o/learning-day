defmodule Belfrage.Cache.Store do
  alias Belfrage.Cache.MultiStrategy
  alias Belfrage.Cache.Local
  alias Belfrage.Metrics

  def store(struct) do
    cond do
      store_in_local_and_distributed_cache?(struct) ->
        Metrics.duration(:cache_response, fn ->
          MultiStrategy.store(struct)
        end)

        struct

      store_in_local_cache?(struct) ->
        Metrics.duration(:cache_response, fn ->
          Local.store(struct, make_stale: true)
        end)

        struct

      true ->
        struct
    end
  end

  defp store_in_local_and_distributed_cache?(struct) do
    is_cacheable?(struct) and not is_response_fallback?(struct)
  end

  defp store_in_local_cache?(struct) do
    is_cacheable?(struct) and is_response_fallback?(struct) and
      struct.response.cache_type == :distributed
  end

  defp is_cacheable?(struct) do
    is_caching_enabled?(struct) and is_successful_response?(struct) and is_get_request?(struct) and
      is_public_cacheable_response?(struct)
  end

  defp is_public_cacheable_response?(struct) do
    case struct.response.cache_directive do
      %Belfrage.CacheControl{cacheability: "public", max_age: max_age} when is_integer(max_age) -> true
      _ -> false
    end
  end

  defp is_successful_response?(struct) do
    struct.response.http_status == 200
  end

  defp is_get_request?(struct) do
    struct.request.method == "GET"
  end

  defp is_caching_enabled?(struct) do
    struct.private.caching_enabled
  end

  defp is_response_fallback?(struct) do
    struct.response.fallback
  end
end
