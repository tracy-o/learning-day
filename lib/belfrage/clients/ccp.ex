defmodule Belfrage.Clients.CCP do
  @moduledoc """
  The interface to the Belfrage Central Cache Processor (CCP)
  """
  alias Belfrage.{Clients, Struct, Struct.Request}

  @http_client Application.get_env(:belfrage, :http_client, Clients.HTTP)

  @type target :: Pid.t() | {:global, Atom.t()}
  @callback fetch(String.t()) :: {:ok, :content_not_found} | {:ok, :fresh, Struct.Response.t()} | {:ok, :stale, Struct.Response.t()}
  @callback put(Struct.t()) :: :ok
  @callback put(Struct.t(), target) :: :ok

  @spec put(Struct.t()) :: :ok
  def fetch(request_hash) do
    @http_client.execute(%Clients.HTTP.Request{
       method: :get,
       url: "s3://" <> s3_bucket() <> request_hash,
     })

    # {:ok, :content_not_found}
  end

  @spec put(Struct.t()) :: :ok
  @spec put(Struct.t(), target) :: :ok
  def put(
        struct = %Struct{
          request: %Request{request_hash: request_hash},
          response: response
        },
        target \\ {:global, :belfrage_ccp}
      ) do
    GenServer.cast(target, {:put, request_hash, response})
  end

  defp s3_bucket do
    # TODO fetch runtime config var
  end
end
