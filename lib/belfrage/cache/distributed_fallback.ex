defmodule Belfrage.Cache.DistributedFallback do
  alias Belfrage.{Struct, Struct.Request}
  alias Belfrage.Behaviours.CacheStrategy
  @behaviour CacheStrategy

  @impl CacheStrategy
  def fetch(%Struct{request: %Request{request_hash: key}}) do
    # TODO fetch from S3 here (RESFRAME-3355)
    result = {:ok, :content_not_found}

    result
  end

  @impl CacheStrategy
  def store(struct) do
    Belfrage.CCP.put(struct)

    {:ok, true}
  end

  @impl CacheStrategy
  def metric_identifier, do: "distributed"
end
