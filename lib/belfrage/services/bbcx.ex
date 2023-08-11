defmodule Belfrage.Services.BBCX do
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
      "req-svc-chain" => request.req_svc_chain,
      "country" => request.country
    }
    |> Map.merge(request.raw_headers)
  end
end
