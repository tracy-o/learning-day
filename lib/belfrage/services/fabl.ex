defmodule Belfrage.Services.Fabl do
  require Belfrage.Event

  alias Belfrage.Behaviours.Service
  alias Belfrage.{Clients, Struct}
  alias Belfrage.Services.Fabl.Request

  @http_client Application.get_env(:belfrage, :http_client, Clients.HTTP)

  @behaviour Service

  @impl Service
  def dispatch(struct = %Struct{}) do
    Belfrage.Event.record "function.timing.service.Fabl.request" do
      struct
      |> execute_request()
      |> handle_response()
    end
  end

  defp execute_request(struct) do
    {@http_client.execute(
       Request.build(struct),
       :Fabl
     ), struct}
  end

  defp handle_response({{:ok, %Clients.HTTP.Response{status_code: status, body: body, headers: headers}}, struct}) do
    Belfrage.Event.record(:metric, :increment, "service.Fabl.response.#{status}")
    Map.put(struct, :response, %Struct.Response{http_status: status, body: body, headers: headers})
  end

  defp handle_response({{:error, %Clients.HTTP.Error{reason: :timeout}}, struct}) do
    Belfrage.Event.record(:metric, :increment, "error.service.Fabl.timeout")
    log(:timeout, struct)
    Struct.add(struct, :response, %Struct.Response{http_status: 500, body: ""})
  end

  defp handle_response({{:error, error}, struct}) do
    Belfrage.Event.record(:metric, :increment, "error.service.Fabl.request")
    log(error, struct)
    Struct.add(struct, :response, %Struct.Response{http_status: 500, body: ""})
  end

  defp log(reason, struct) do
    Belfrage.Event.record(:log, :error, %{
      msg: "Fabl Service request error",
      reason: reason,
      struct: Struct.loggable(struct)
    })
  end
end
