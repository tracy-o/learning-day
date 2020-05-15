defmodule Belfrage.Services.Fabl do
  use ExMetrics

  alias Belfrage.Behaviours.Service
  alias Belfrage.{Clients, Struct}
  alias Belfrage.Helpers.QueryParams

  @http_client Application.get_env(:belfrage, :http_client, Clients.HTTP)

  @behaviour Service

  @impl Service
  def dispatch(struct = %Struct{}) do
    ExMetrics.timeframe "function.timing.service.Fabl.request" do
      struct
      |> execute_request()
      |> handle_response()
    end
  end

  defp handle_response({{:ok, %Clients.HTTP.Response{status_code: status, body: body, headers: headers}}, struct}) do
    ExMetrics.increment("service.Fabl.response.#{status}")
    Map.put(struct, :response, %Struct.Response{http_status: status, body: body, headers: headers})
  end

  defp handle_response({{:error, %Clients.HTTP.Error{reason: :timeout}}, struct}) do
    ExMetrics.increment("error.service.Fabl.timeout")
    log(:timeout, struct)
    Struct.add(struct, :response, %Struct.Response{http_status: 500, body: ""})
  end

  defp handle_response({{:error, error}, struct}) do
    ExMetrics.increment("error.service.Fabl.request")
    log(error, struct)
    Struct.add(struct, :response, %Struct.Response{http_status: 500, body: ""})
  end

  defp log(reason, struct) do
    Stump.log(:error, %{
      msg: "Fabl Service request error",
      reason: reason,
      struct: Struct.loggable(struct)
    })
  end

  defp execute_request(
         struct = %Struct{
           request: request = %Struct.Request{method: "GET", path: path, path_params: params},
           private: private
         }
       ) do
    {@http_client.execute(
       %Clients.HTTP.Request{
         method: :get,
         url: private.origin <> module_path(path) <> params["name"] <> QueryParams.encode(request.query_params),
         headers: build_headers()
       },
       :fabl
     ), struct}
  end

  defp module_path("/fd/preview/" <> _rest_of_path), do: "/preview/module/"
  defp module_path(_path), do: "/module/"

  defp build_headers do
    %{"accept-encoding" => "gzip", "user-agent" => "Belfrage"}
  end
end
