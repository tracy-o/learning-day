defmodule Belfrage.Clients.CCP do
  @moduledoc """
  The interface to the Belfrage Central Cache Processor (CCP)
  """
  alias Belfrage.{Clients, Struct, Struct.Request}

  @http_client Application.get_env(:belfrage, :http_client, Clients.HTTP)

  @type target :: Pid.t() | {:global, Atom.t()}
  @callback fetch(String.t()) ::
              {:ok, :content_not_found} | {:ok, :fresh, Struct.Response.t()} | {:ok, :stale, Struct.Response.t()}
  @callback put(Struct.t()) :: :ok
  @callback put(Struct.t(), target) :: :ok

  @spec fetch(String.t()) :: {:ok, :content_not_found} | {:ok, :stale, Struct.Response.t()}
  def fetch(request_hash) do
    # TODO Investigate using ExAws.S3 to fetch fallbacks securely.
    # https://aws.amazon.com/premiumsupport/knowledge-center/s3-private-connection-no-authentication/
    @http_client.execute(%Clients.HTTP.Request{
      method: :get,
      url: ~s(https://#{s3_bucket()}.s3-eu-west-1.amazonaws.com/#{request_hash})
    })
    |> case do
      {:ok, %Clients.HTTP.Response{status_code: 200, body: cached_body}} ->
        {:ok, :stale, cached_body |> :erlang.binary_to_term()}

      {:ok, %Clients.HTTP.Response{status_code: 404}} ->
        {:ok, :content_not_found}

      {:ok, response} ->
        ExMetrics.increment("ccp.fetch_error")
        Stump.log(:error, %{
          msg: "Failed to fetch from S3.",
          response: response
        })

        {:ok, :content_not_found}
    end
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
    Application.get_env(:belfrage, :ccp_s3_bucket, "belfrage-t2-cache")
  end
end
