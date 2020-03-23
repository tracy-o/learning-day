defmodule Belfrage.CCP do
  @moduledoc """
  The interface to the Belfrage Central Cache Processor (CCP)
  """
  alias Belfrage.{Struct, Struct.Request}

  @spec put(Struct.t(), Pid.t()) :: :ok
  @spec put(Struct.t(), {:global, Atom.t()}) :: :ok
  def put(
        struct = %Struct{
          request: %Request{request_hash: request_hash},
          response: response
        },
        target \\ {:global, :belfrage_ccp}
      ) do
    GenServer.cast(target, {:put, request_hash, response})
  end
end
