defmodule Belfrage.Services.Webcore do
  alias Belfrage.{Struct, Event, Metrics}
  alias Belfrage.Struct.{Request, Response, Private}
  alias Belfrage.Services.Webcore
  alias Belfrage.Behaviours.Service
  alias Belfrage.Xray

  @behaviour Service
  @lambda_client Application.get_env(:belfrage, :lambda_client, Belfrage.Clients.Lambda)

  @impl Service
  def dispatch(struct = %Struct{private: private = %Private{}}) do
    response =
      with {:ok, response} <- call_lambda(struct),
           {:ok, response} <- build_response(response) do
        Metrics.event(~w(webcore response)a, %{status_code: response.http_status, route_spec: private.route_state_id})
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

    Struct.add(struct, :response, response)
  end

  defp call_lambda(struct = %Struct{request: request = %Request{}, private: private = %Private{}}) do
    metadata = %{
      route_spec: private.route_state_id,
      struct: struct
    }

    Metrics.duration(~w(webcore request)a, metadata, fn ->
      @lambda_client.call(
        Webcore.Credentials.get(),
        private.origin,
        Webcore.Request.build(struct),
        request.request_id,
        lambda_options(struct.request)
      )
    end)
  end

  defp lambda_options(request = %Struct.Request{}) do
    if request.xray_segment do
      trace_id = Xray.build_trace_id_header(request.xray_segment)
      [xray_trace_id: trace_id]
    else
      []
    end
  end

  defp build_response(response = %{"body" => body, "headers" => headers, "statusCode" => status_code}) do
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

  defp build_response(invalid_response) do
    Event.record(:log, :debug, %{
      msg: "Received an invalid response from web core",
      web_core_response: invalid_response
    })

    {:error, :invalid_web_core_contract}
  end
end
