defmodule Belfrage.Services.Webcore do
  require Logger
  alias Belfrage.{Struct, Metrics}
  alias Belfrage.Struct.{Request, Response, Private}
  alias Belfrage.Services.Webcore
  alias Belfrage.Behaviours.Service
  alias Belfrage.Xray
  alias Belfrage.Metrics.LatencyMonitor

  @behaviour Service

  @impl Service
  def dispatch(struct = %Struct{private: private = %Private{}}) do
    struct = LatencyMonitor.checkpoint(struct, :origin_request_sent)

    response =
      with {:ok, response} <- call_lambda(struct),
           {:ok, response} <- build_response(response) do
        Metrics.multi_execute([[:belfage, :webcore, :response], [:belfrage, :platform, :response]], %{}, %{
          platform: "Webcore",
          status_code: response.http_status,
          route_spec: private.route_state_id
        })

        response
      else
        {:error, error_code} ->
          Metrics.event(~w(webcore error)a, %{error_code: error_code, route_spec: private.route_state_id})

          {status_code, body} = status_from_error(error_code, private.preview_mode)

          :telemetry.execute([:belfrage, :platform, :response], %{}, %{
            platform: "Webcore",
            status_code: status_code,
            route_spec: private.route_state_id
          })

          %Response{http_status: status_code, body: body}
      end

    struct = LatencyMonitor.checkpoint(struct, :origin_response_received)
    Struct.add(struct, :response, response)
  end

  defp call_lambda(struct = %Struct{request: %Request{}, private: private = %Private{}}) do
    metadata = %{
      route_spec: private.route_state_id,
      struct: struct
    }

    Metrics.duration(~w(webcore request)a, metadata, fn ->
      lambda_client().call(
        Webcore.Credentials.get(),
        private.origin,
        Webcore.Request.build(struct),
        lambda_options(struct.request)
      )
    end)
  end

  defp lambda_options(request = %Struct.Request{}) do
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

  defp status_from_error(:invalid_query_string, _preview_mode), do: {404, "404 - not found"}

  defp status_from_error(:function_not_found, "on"), do: {404, "404 - not found"}

  defp status_from_error(_error, _preview_mode), do: {500, ""}
end
