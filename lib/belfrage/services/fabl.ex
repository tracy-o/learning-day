defmodule Belfrage.Services.Fabl do
  require Belfrage.Event

  alias Belfrage.Behaviours.Service
  alias Belfrage.{Clients, Struct}
  alias Belfrage.Struct.UserSession
  alias Belfrage.Xray
  alias Belfrage.Helpers.QueryParams

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

  defp execute_request(
         struct = %Struct{
           request: request = %Struct.Request{method: "GET", path: path, path_params: params, request_id: request_id},
           private: private,
           user_session: user_session
         }
       ) do
    {@http_client.execute(
       %Clients.HTTP.Request{
         method: :get,
         url: private.origin <> module_path(path) <> params["name"] <> QueryParams.encode(request.query_params),
         headers: build_headers(request, user_session),
         request_id: request_id
       },
       :Fabl
     ), struct}
  end

  defp module_path("/fd/preview/" <> _rest_of_path), do: "/preview/module/"
  defp module_path(_path), do: "/module/"

  defp build_headers(request, user_session) do
    request
    |> base_headers()
    |> IO.inspect()
    |> put_user_session_headers(user_session)
  end

  defp base_headers(%Struct.Request{
         raw_headers: raw_headers,
         req_svc_chain: req_svc_chain,
         xray_segment: nil
       }) do
    Map.merge(raw_headers, %{
      "accept-encoding" => "gzip",
      "user-agent" => "Belfrage",
      "req-svc-chain" => req_svc_chain
    })
  end

  defp base_headers(%Struct.Request{
         raw_headers: raw_headers,
         req_svc_chain: req_svc_chain,
         xray_segment: segment
       }) do
    Map.merge(raw_headers, %{
      "accept-encoding" => "gzip",
      "user-agent" => "Belfrage",
      "req-svc-chain" => req_svc_chain,
      "x-amzn-trace-id" => Xray.build_trace_id_header(segment)
    })
  end

  defp put_user_session_headers(headers, user_session = %UserSession{}) do
    if user_session.valid_session do
      headers
      |> Map.put(:authorization, "Bearer #{user_session.session_token}")
      |> Map.put(:"x-authentication-provider", "idv5")
      |> Map.put(:"pers-env", user_session.authentication_env)
      |> put_user_attributes(user_session.user_attributes)
    else
      headers
    end
  end

  defp put_user_attributes(headers, user_attributes) do
    case user_attributes do
      %{age_bracket: age_bracket, allow_personalisation: allow_personalisation} ->
        headers
        |> Map.put(:"ctx-pii-age-bracket", age_bracket)
        |> Map.put(:"ctx-pii-allow-personalisation", to_string(allow_personalisation))

      _ ->
        headers
    end
  end
end
