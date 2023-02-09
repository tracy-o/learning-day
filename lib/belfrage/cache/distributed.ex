defmodule Belfrage.Cache.Distributed do
  alias Belfrage.{Envelope, Envelope.Request, Envelope.Response}
  alias Belfrage.Behaviours.CacheStrategy
  import Enum, only: [random: 1]
  @behaviour CacheStrategy

  @ccp_client Application.compile_env(:belfrage, :ccp_client)

  @impl CacheStrategy
  def fetch(%Envelope{request: %Request{request_hash: request_hash}}) do
    with {:ok, response = %Response{}} <- @ccp_client.fetch(request_hash) do
      {:ok, {:distributed, :stale}, response}
    end
  end

  @impl CacheStrategy
  def store(envelope), do: store(envelope, sampled?(envelope.private.fallback_write_sample))
  defp store(_envelope, false), do: {:ok, false}

  defp store(envelope, true) do
    @ccp_client.put(envelope)

    {:ok, true}
  end

  defp sampled?(fallback_write_sample), do: random(0..99) < fallback_write_sample * 100

  @impl CacheStrategy
  def metric_identifier, do: "distributed"
end
