defmodule Belfrage.Services.HTTP do
  use ExMetrics

  alias Belfrage.Behaviours.Service
  alias Belfrage.{Clients, Struct}
  alias Belfrage.Helpers.QueryParams

  @http_client Application.get_env(:belfrage, :http_client, Clients.HTTP)

  @behaviour Service

  @impl Service
  def dispatch(struct = %Struct{}) do
    ExMetrics.timeframe "function.timing.service.HTTP.request" do
      execute_request(struct)
      |> handle_response()
    end
  end

  defp handle_response({{:ok, %MachineGun.Response{status_code: status, body: body}}, struct}) do
    ExMetrics.increment("service.HTTP.response.#{status}")
    if status > 200, do: log(status, body, struct)
    Map.put(struct, :response, %Struct.Response{http_status: status, body: body})
  end

  defp handle_response({{:error, %{reason: :timeout}}, struct}) do
    ExMetrics.increment("error.service.HTTP.timeout")
    log(:timeout, struct)
    Struct.add(struct, :response, %Struct.Response{http_status: 500, body: ""})
  end

  defp handle_response({{:error, error}, struct}) do
    ExMetrics.increment("error.service.HTTP.request")
    log(error, struct)
    Struct.add(struct, :response, %Struct.Response{http_status: 500, body: ""})
  end

  defp log(reason, struct) do
    Stump.log(:error, %{
      msg: "HTTP Service request error",
      reason: reason,
      struct: Map.from_struct(struct)
    })
  end

  defp log(status, body, struct) do
    Stump.log(:error, %{
      msg: "Non 200 response from HTTP Service request",
      status: status,
      body: body,
      struct: Map.from_struct(struct)
    })
  end

  defp execute_request(struct = %Struct{request: request = %Struct.Request{method: "POST"}, private: private}) do
    {@http_client.request(
       :post,
       private.origin <> request.path <> QueryParams.parse(request.query_params),
       request.payload
     ), struct}
  end

  defp execute_request(struct = %Struct{request: request = %Struct.Request{method: "GET"}, private: private}) do
    {@http_client.request(:get, private.origin <> request.path <> QueryParams.parse(request.query_params)), struct}
  end
end
