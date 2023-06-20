defmodule Belfrage.Services.Webcore.Request do
  alias Belfrage.Envelope
  alias Belfrage.Envelope.{Request, Private, UserSession, RouteState}
  alias Belfrage.{Mvt, RouteState}

  def build(envelope) do
    %{
      headers: headers(envelope),
      body: nil,
      httpMethod: envelope.request.method,
      path: envelope.request.path,
      queryStringParameters: envelope.request.query_params,
      pathParameters: envelope.request.path_params
    }
  end

  defp headers(envelope = %Envelope{}) do
    envelope
    |> base_headers()
    |> put_obit_mode_headers(envelope.request)
    |> put_election_headers(envelope.request)
    |> put_is_commercial_header(envelope.request)
    |> put_user_session_headers(envelope.user_session)
    |> put_feature_header(envelope.private)
    |> Mvt.Headers.put_mvt_headers(envelope.private)
  end

  defp base_headers(%Envelope{request: request = %Request{}, private: private = %Private{}}) do
    %{
      country: request.country,
      language: request.language,
      "accept-encoding": "gzip",
      is_uk: request.is_uk,
      host: request.host,
      "ctx-route-spec": RouteState.format_id(private.route_state_id)
    }
  end

  defp put_obit_mode_headers(headers, %Request{raw_headers: raw_headers}) do
    if raw_headers["obit-mode"] do
      Map.put(headers, "obm", raw_headers["obit-mode"])
    else
      headers
    end
  end

  defp put_election_headers(headers, %Request{raw_headers: raw_headers}) do
    headers =
      if raw_headers["election-banner-council-story"] do
        headers
        |> Map.put("election-banner-council-story", raw_headers["election-banner-council-story"])
      else
        headers
      end

    if raw_headers["election-banner-ni-story"] do
      headers
      |> Map.put("election-banner-ni-story", raw_headers["election-banner-ni-story"])
    else
      headers
    end
  end

  defp put_is_commercial_header(headers, %Request{raw_headers: raw_headers}) do
    if raw_headers["is_commercial"] do
      headers
      |> Map.put("is_commercial", raw_headers["is_commercial"])
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

  # This still doesn't cover partial presence of attributes
  # that will be covered by RESFRAME-4284
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

  defp put_feature_header(headers, private = %Private{}) do
    if private.features == %{} do
      headers
    else
      value = private.features |> Enum.map(&Tuple.to_list/1) |> Enum.map_join(",", &Enum.join(&1, "="))
      Map.put(headers, :"ctx-features", value)
    end
  end
end
