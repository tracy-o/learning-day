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
  def store(struct) do
    dial_state = @dial.state(:ccp_bypass)

    IO.inspect("HUH")
    IO.inspect(dial_state)

    # store(struct, @dial.state(:ccp_bypass))
    # if not @dial.state(:ccp_bypass) do
    @ccp_client.put(struct)
    # end

    {:ok, true}
  end

  # defp store(struct, true), do: {:ok, false}

  # defp store(struct, false) do
  #   @ccp_client.put(struct)

  #   {:ok, true}
  # end

  # defp store(struct, something_else) do
  #   IO.inspect("WHAT")
  #   IO.inspect(something_else)
  #   {:error, something_else}
  # end

  @impl CacheStrategy
  def metric_identifier, do: "distributed"
end
