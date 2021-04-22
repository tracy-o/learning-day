defmodule Belfrage.Cache.Distributed do
  alias Belfrage.{Struct, Struct.Request}
  alias Belfrage.Behaviours.CacheStrategy
  @behaviour CacheStrategy

  @ccp_client Application.get_env(:belfrage, :ccp_client)
  @dial Application.get_env(:belfrage, :dial)

  @impl CacheStrategy
  def fetch(%Struct{request: %Request{request_hash: request_hash}}) do
    @ccp_client.fetch(request_hash)
  end

  @impl CacheStrategy
  def store(struct), do: store(struct, @dial.state(:ccp_bypass))
  defp store(struct, true), do: {:ok, false}
  defp store(struct, false) do
    @ccp_client.put(struct)

    {:ok, true}
  end

  @impl CacheStrategy
  def metric_identifier, do: "distributed"
end
