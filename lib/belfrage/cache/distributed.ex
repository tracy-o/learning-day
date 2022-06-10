defmodule Belfrage.Cache.Distributed do
  alias Belfrage.{Struct, Struct.Request, Struct.Response}
  alias Belfrage.Behaviours.CacheStrategy
  import Enum, only: [random: 1]
  @behaviour CacheStrategy

  @ccp_client Application.get_env(:belfrage, :ccp_client)
  @dial Application.get_env(:belfrage, :dial)

  @impl CacheStrategy
  def fetch(%Struct{request: %Request{request_hash: request_hash}}) do
    with {:ok, response = %Response{}} <- @ccp_client.fetch(request_hash) do
      {:ok, {:distributed, :stale}, response}
    end
  end

  @impl CacheStrategy
  def store(struct), do: store(struct, should_store?(@dial.state(:ccp_enabled), struct.private.fallback_write_sample))
  defp store(_struct, false), do: {:ok, false}

  defp store(struct, true) do
    @ccp_client.put(struct)

    {:ok, true}
  end

  defp should_store?(false, _fallback_write_sample), do: false
  defp should_store?(true, fallback_write_sample), do: random(0..100) < fallback_write_sample * 100

  @impl CacheStrategy
  def metric_identifier, do: "distributed"
end
