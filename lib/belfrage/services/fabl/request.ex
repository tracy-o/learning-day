defmodule Belfrage.Services.Fabl.Request do
  alias Belfrage.{Clients, Struct}
  alias Belfrage.Struct.{Request, UserSession}
  alias Belfrage.Xray
  alias Belfrage.Helpers.QueryParams

  def build(%Struct{
        request: request = %Struct.Request{method: "GET", path: path, path_params: params, request_id: request_id},
        private: private,
        user_session: user_session
      }) do
    %Clients.HTTP.Request{
      method: :get,
      url:
        private.origin <>
          module_path(path, private.personalised_route) <> params["name"] <> QueryParams.encode(request.query_params),
      headers: build_headers(request, user_session),
      request_id: request_id
    }
  end

  defp module_path("/fd/preview/" <> _rest_of_path, true), do: "/preview/personalised-module/"
  defp module_path(_path, true), do: "/personalised-module/"
  defp module_path("/fd/preview/" <> _rest_of_path, false), do: "/preview/module/"
  defp module_path(_path, false), do: "/module/"

  defp build_headers(request, user_session) do
    request
    |> base_headers()
    |> put_xray_header(request.xray_segment)
    |> put_user_session_headers(user_session)
  end

  defp base_headers(%Request{
         raw_headers: raw_headers,
         req_svc_chain: req_svc_chain
       }) do
    Map.merge(raw_headers, %{
      "accept-encoding" => "gzip",
      "user-agent" => "Belfrage",
      "req-svc-chain" => req_svc_chain
    })
  end

  defp put_xray_header(headers, segment) do
    if segment do
      Map.put(headers, "x-amzn-trace-id", Xray.build_trace_id_header(segment))
    else
      headers
    end
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
