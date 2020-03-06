defmodule Belfrage.Cache.CCP do
  alias Belfrage.Behaviours.CacheStrategy
  @behaviour CacheStrategy

  @impl CacheStrategy
  def fetch(%{request: %{request_hash: key}}) do
    Node.list()
    |> List.first()
    |> fetch_from_ccp(key)
  end

  defp fetch_from_ccp(_node = nil, _key) do
    Stump.log(:error, %{msg: "Belfrage CCP is not connected to Belfrage."})
    {:ok, :content_not_found}
  end

  defp fetch_from_ccp(node, key) do
    case :rpc.call(node, BelfrageCcp, :get, [key]) do
      {:ok, response} -> {:ok, :stale, response}
      _ -> {:ok, :content_not_found}
    end
  end

  @impl CacheStrategy
  def store(struct = %Belfrage.Struct{}) do
    Node.list()
    |> List.first()
    |> send_to_ccp(struct)
  end

  defp send_to_ccp(_node = nil, _struct) do
    Stump.log(:error, %{
      msg: "Belfrage CCP is not connected to Belfrage."
    })

    {:ok, false}
  end

  defp send_to_ccp(node, %Belfrage.Struct{
         request: %{request_hash: request_hash},
         response: response
       }) do
    GenServer.cast({BelfrageCcp, node}, {:put, request_hash, response})

    {:ok, true}
  end
end
