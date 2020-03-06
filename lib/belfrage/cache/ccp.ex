defmodule Belfrage.Cache.CCP do
  alias Belfrage.Behaviours.CacheStrategy
  @behaviour CacheStrategy

  @impl CacheStrategy
  def fetch(%Belfrage.Struct{
        request: %{request_hash: request_hash}
      }) do
    {:error, "Belfrage.Cache.CCP.fetch/1 not implemented."}
  end

  @impl CacheStrategy
  def store(struct = %Belfrage.Struct{}) do
    Node.list()
    |> List.first()
    |> send_to_ccp(struct)
  end

  defp send_to_ccp(node = nil, _struct) do
    Stump.log(:error, %{
      msg: "Belfrage CCP is not connected to Belfrage."
    })

    {:ok, false}
  end

  defp send_to_ccp(node, %Belfrage.Struct{
         request: %{request_hash: request_hash},
         response: response
       }) do
    GenServer.cast({BelfrageCcp, node}, {:store, request_hash, response})

    {:ok, true}
  end
end
