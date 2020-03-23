defmodule Belfrage.Cache.DistributedFallback do
  alias Belfrage.{Struct, Struct.Request}
  @behaviour CacheStrategy

  @impl CacheStrategy
  def fetch(%Struct{request: %Request{request_hash: key}}) do
    # TODO fetch from S3 here (RESFRAME-3355)
    result = {:ok, :content_not_found}

    result
    |> metric_if_misses()
  end

  @impl CacheStrategy
  def store(struct = %Struct{
    request: %Request{request_hash: request_hash},
    response: response
    }) do
    Belfrage.CCP.put(struct)

    {:ok, true}
  end

  defp metric_if_misses(result = {:ok, :content_not_found}) do
    ExMetrics.increment("cache.distributed.fallback_item_does_not_exist")

    result
  end

  defp metric_if_misses(result), do: result
end
