defmodule Belfrage.Cache.Distributed do
  alias Belfrage.{Envelope, Envelope.Request, Envelope.Response}
  alias Belfrage.Behaviours.CacheStrategy
  import Enum, only: [random: 1]
  @behaviour CacheStrategy

  @ccp_client Application.compile_env(:belfrage, :ccp_client)

  @moduledoc """
    This module contains the logic for sending items to Belfrage CCP which stores responses in S3, you will often hear this module described as S3.
    Before sending the item to CCP the cache key is amended to include the path of the request.
    Given:
    path = "/news/live"
    request_hash = "this-is-my-request-hash"
    The following cache key will be sent to CCP:
    distributed_cache_key = "/news/live/this-is-my-request-hash"
  """

  @impl CacheStrategy
  def fetch(%Envelope{request: %Request{request_hash: request_hash, path: path}}) do
    with {:ok, response = %Response{}} <- @ccp_client.fetch(prepend_path(path, request_hash)) do
      {:ok, {:distributed, :stale}, response}
    end
  end

  @impl CacheStrategy
  def store(envelope = %Envelope{request: %Request{path: path, request_hash: request_hash}}) do
    updated_envelope = Envelope.add(envelope, :request, %{request_hash: prepend_path(path, request_hash)})
    store(updated_envelope, sampled?(envelope.private.fallback_write_sample))
  end

  defp store(_envelope, false), do: {:ok, false}

  defp store(envelope, true) do
    @ccp_client.put(envelope)

    {:ok, true}
  end

  defp sampled?(fallback_write_sample), do: random(0..99) < fallback_write_sample * 100

  @impl CacheStrategy
  def metric_identifier, do: "distributed"

  def prepend_path(path, hash) do
    truncated_path = truncate_path(path)
    truncated_path <> "/" <> hash
  end

  defp truncate_path(path) do
    String.slice(path, 0..499)
  end
end
