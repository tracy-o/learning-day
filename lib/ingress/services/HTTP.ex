defmodule Ingress.Services.HTTP do
  alias Ingress.Behaviours.Service
  alias Ingress.HTTPClient
  alias Ingress.Struct

  @http_client Application.get_env(:ingress, :http_client, HTTPClient)

  @behaviour Service

  @impl Service
  def dispatch(struct = %Struct{}) do
    execute_request(struct)
    |> handle_response()
  end

  defp handle_response({{:ok, %HTTPoison.Response{status_code: status, body: body}}, struct}) do
    Map.put(struct, :response, %Struct.Response{http_status: status, body: body})
  end

  defp handle_response({{:error, _reason}, struct}) do
    # Log error and add debug info to struct
    struct
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
