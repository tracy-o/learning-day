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

  def handle_response({{:ok, %HTTPoison.Response{status_code: status, body: body}}, struct}) do
    Map.put(struct, :response, %Struct.Response{http_status: status, body: body})
  end

  def handle_response({{:error, _reason}, struct}) do
    # Log error and add debug info to struct
    struct
  end

  def execute_request(struct = %Struct{request: request, private: private}) do
    {case request.method do
       "GET" -> @http_client.get(private.origin, request.path)
       "POST" -> @http_client.post(private.origin, request.path, request.payload)
     end, struct}
  end
end
