defmodule Belfrage.Services.Webcore do
  require Logger
  alias Belfrage.{Envelope, Metrics, RouteState}
  alias Belfrage.Envelope.{Request, Response, Private}
  alias Belfrage.Services.Webcore
  alias Belfrage.Behaviours.Service
  alias Belfrage.Xray
  alias Belfrage.Metrics.LatencyMonitor

  @behaviour Service

  @impl Service
  def dispatch(envelope = %Envelope{private: private = %Private{}}) do
    envelope = LatencyMonitor.checkpoint(envelope, :origin_request_sent)
    route_spec = RouteState.format_id(private.route_state_id)

    response =
      with {:ok, response} <- call_lambda(envelope),
           {:ok, response} <- build_response(response) do
        Metrics.multi_execute([[:belfage, :webcore, :response], [:belfrage, :platform, :response]], %{}, %{
          platform: "Webcore",
          status_code: response.http_status,
          route_spec: route_spec
        })

        response
      else
        {:error, error_code} ->
          Metrics.event(~w(webcore error)a, %{error_code: error_code, route_spec: route_spec})

          {status_code, body} = status_from_error(error_code, private.preview_mode)

          :telemetry.execute([:belfrage, :platform, :response], %{}, %{
            platform: "Webcore",
            status_code: status_code,
            route_spec: route_spec
          })

          %Response{http_status: status_code, body: body}
      end

    envelope = LatencyMonitor.checkpoint(envelope, :origin_response_received)
    Envelope.add(envelope, :response, response)
  end

  defp call_lambda(envelope = %Envelope{request: %Request{}, private: private = %Private{}}) do
    metadata = %{
      route_spec: RouteState.format_id(private.route_state_id),
      envelope: envelope
    }

    Metrics.duration(~w(webcore request)a, metadata, fn ->
      lambda_client().call(
        Webcore.Credentials.get(),
        private.origin,
        Webcore.Request.build(envelope),
        lambda_options(envelope.request)
      )
    end)
  end

  defp lambda_options(request = %Envelope.Request{}) do
    if request.xray_segment do
      [xray_trace_id: Xray.build_trace_id_header(request.xray_segment)]
    else
      []
    end
  end

  def build_response(response = %{"body" => body, "headers" => headers, "statusCode" => status_code}) do
    headers =
      headers
      |> Enum.map(fn {key, value} -> {key, to_string(value)} end)
      |> Map.new()

    body =
      if response["isBase64Encoded"] do
        # b64fast doesn't return an error when the input is not actually Base64
        # encoded, it just attempts to decode it anyway.
        :b64fast.decode64(body)
      else
        body
      end

    {:ok,
     %Response{
       http_status: status_code,
       headers: headers,
       body: body
     }}
  end

  def build_response(invalid_response) do
    Logger.log(:debug, "", %{
      msg: "Received an invalid response from web core",
      web_core_response: invalid_response
    })

    {:error, :invalid_web_core_contract}
  end

  defp lambda_client(), do: Application.get_env(:belfrage, :lambda_client, Belfrage.Clients.Lambda)

  defp status_from_error(:invalid_query_string, _preview_mode), do: {404, ""}

  defp status_from_error(:function_not_found, "on"), do: {404, "404 - not found"}

  defp status_from_error(_error, _preview_mode), do: {500, ""}
end
