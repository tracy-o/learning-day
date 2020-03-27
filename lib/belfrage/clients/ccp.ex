defmodule Belfrage.Clients.CCP do
  @moduledoc """
  The interface to the Belfrage Central Cache Processor (CCP)
  """
  alias Belfrage.{Struct, Struct.Request}

  @spec put(Struct.t()) :: :ok
  def put(
        struct = %Struct{
          request: %Request{request_hash: request_hash},
          response: response
        }
      ) do
    GenServer.cast({:global, :belfrage_ccp}, {:put, request_hash, response})
  end
end
