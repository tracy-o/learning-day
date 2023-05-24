defmodule Belfrage.Services.Fabl do
  require Logger

  alias Belfrage.Behaviours.Service
  alias Belfrage.{Clients, Envelope, Envelope.Private}
  alias Belfrage.Services.Fabl.Request

  @http_client Application.compile_env(:belfrage, :http_client, Clients.HTTP)

  @behaviour Service

  @impl Service
  def dispatch(envelope = %Envelope{private: %Private{spec: route_spec, platform: platform, partition: partition}}) do
    :telemetry.span(
      [:belfrage, :function, :timing, :service, :Fabl, :request],
      %{route_spec: route_spec, platform: platform, partition: partition},
      fn ->
        {
          envelope
          |> execute_request()
          |> handle_response(envelope),
          %{route_spec: route_spec, platform: platform, partition: partition}
        }
      end
    )
  end

  defp execute_request(envelope) do
    @http_client.execute(Request.build(envelope), :Fabl)
  end

  defp handle_response(
         {:ok, %Clients.HTTP.Response{status_code: status, body: body, headers: headers}},
         envelope = %Envelope{private: %Private{spec: route_spec, platform: platform, partition: partition}}
       ) do
    Belfrage.Metrics.multi_execute(
      [[:belfrage, :service, :Fabl, :response, String.to_atom(to_string(status))], [:belfrage, :platform, :response]],
      %{count: 1},
      %{route_spec: route_spec, platform: platform, partition: partition, status_code: status}
    )

    Map.put(envelope, :response, %Envelope.Response{http_status: status, body: body, headers: headers})
  end

  defp handle_response({:error, %Clients.HTTP.Error{reason: reason = :timeout}}, envelope) do
    handle_error_resp(reason, reason, envelope)
  end

  defp handle_response({:error, reason}, envelope) do
    handle_error_resp(reason, :request, envelope)
  end

  defp handle_error_resp(
         reason,
         metric,
         envelope = %Envelope{private: %Private{spec: route_spec, platform: platform, partition: partition}}
       ) do
    :telemetry.execute([:belfrage, :error, :service, :Fabl, metric], %{})

    :telemetry.execute(
      [:belfrage, :platform, :response],
      %{},
      %{route_spec: route_spec, platform: platform, partition: partition, status_code: 500}
    )

    log(reason, envelope)
    Envelope.add(envelope, :response, %Envelope.Response{http_status: 500, body: ""})
  end

  defp log(reason, envelope) do
    Logger.log(:error, "", %{
      msg: "Fabl Service request error",
      reason: reason,
      envelope: Envelope.loggable(envelope)
    })
  end
end
