defmodule Belfrage.Services.BBCX do
  require Logger

  alias Belfrage.Services.Dispatcher
  alias Belfrage.Behaviours.Service
  alias Belfrage.Envelope

  @behaviour Service

  @impl Service
  def dispatch(envelope) do
    Dispatcher.dispatch(envelope, build_headers(envelope))
  end

  defp build_headers(%Envelope{request: request}) do
    %{
      "accept-encoding" => "gzip",
      "user-agent" => "Belfrage",
      "req-svc-chain" => request.req_svc_chain
    }
    |> Map.merge(request.raw_headers)
    |> Map.merge(edge_headers(request))
  end

  defp edge_headers(request = %Envelope.Request{edge_cache?: true}) do
    %{
      "x-bbc-edge-country" => request.country
    }
  end

  defp edge_headers(request) do
    %{
      "x-country" => request.country
    }
  end
end
