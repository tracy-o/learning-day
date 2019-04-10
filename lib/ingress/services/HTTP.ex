defmodule Ingress.Services.HTTP do
  use ExMetrics

  alias Ingress.Behaviours.Service
  alias Ingress.{HTTPClient, Struct}

  @http_client Application.get_env(:ingress, :http_client, HTTPClient)

  @behaviour Service

  @impl Service
  def dispatch(struct = %Struct{}) do
    ExMetrics.timeframe "function.timing.service.HTTP.request" do
      execute_request(struct)
      |> handle_response()
    end
  end

  defp handle_response({{:ok, %HTTPoison.Response{status_code: status, body: body}}, struct}) do
    ExMetrics.increment("service.HTTP.response.#{status}")
    if status > 200, do: log(status, body, struct)
    Map.put(struct, :response, %Struct.Response{http_status: status, body: body})
  end

  defp handle_response({{:error, reason}, struct}) do
    ExMetrics.increment("error.service.HTTP.request")

    Stump.log(:error, %{
      msg: "HTTP Service request error",
      reason: reason,
      struct: Map.from_struct(struct)
    })

    struct
  end

  defp log(status, body, struct) do
    Stump.log(:error, %{
      msg: "Non 200 response from HTTP Service request",
      status: status,
      body: body,
      struct: Map.from_struct(struct)
    })
  end

  defp execute_request(
         struct = %Struct{request: request = %Struct.Request{method: "POST"}, private: private}
       ) do
    {@http_client.post(private.origin, request.path, request.payload), struct}
  end

  defp execute_request(
         struct = %Struct{request: request = %Struct.Request{method: "GET"}, private: private}
       ) do
    {@http_client.get(private.origin, request.path), struct}
  end
end
