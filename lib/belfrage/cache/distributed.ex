defmodule Belfrage.Cache.Distributed do
  alias Belfrage.{Struct, Struct.Request}
  alias Belfrage.Behaviours.CacheStrategy
  @behaviour CacheStrategy

  @ccp_client Application.get_env(:belfrage, :ccp_client)

  @impl CacheStrategy
  def fetch(%Struct{request: %Request{request_hash: request_hash}}) do
    @ccp_client.fetch(request_hash)
  end

  @impl CacheStrategy
  def store(struct) do
    @ccp_client.put(struct)

    {:ok, true}
  end

  @impl CacheStrategy
  def metric_identifier, do: "distributed"
end
