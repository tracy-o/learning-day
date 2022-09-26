defmodule Belfrage.Services.Webcore do
  require Logger
  alias Belfrage.{Struct, Metrics}
  alias Belfrage.Struct.{Request, Response, Private}
  alias Belfrage.Services.Webcore
  alias Belfrage.Behaviours.Service
  alias Belfrage.Xray
  alias Belfrage.Metrics.LatencyMonitor

  @behaviour Service
  @lambda_client Application.get_env(:belfrage, :lambda_client, Belfrage.Clients.Lambda)

  @impl Service
  def dispatch(struct = %Struct{private: private = %Private{}}) do
    struct = LatencyMonitor.checkpoint(struct, :origin_request_sent)

    response =
      with {:ok, response} <- call_lambda(struct),
           {:ok, response} <- build_response(response) do
        Metrics.multi_execute([[:belfage, :webcore, :response], [:belfrage, :platform, :response]], %{}, %{
          platform: "Lambda",
          status_code: response.http_status,
          route_spec: private.route_state_id
        })

        response
      else
        {:error, error_code} ->
          Metrics.event(~w(webcore error)a, %{error_code: error_code, route_spec: private.route_state_id})

          if error_code == :function_not_found && private.preview_mode == "on" do
            %Response{http_status: 404, body: "404 - not found"}
          else
            %Response{http_status: 500}
          end
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
      @lambda_client.call(
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
end
