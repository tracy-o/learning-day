defmodule Belfrage.Services.Webcore.Request do
  alias Belfrage.Struct
  alias Belfrage.Struct.{Request, Private, UserSession}

  def build(struct) do
    %{
      headers: headers(struct),
      body: struct.request.payload,
      httpMethod: struct.request.method,
      path: struct.request.path,
      queryStringParameters: struct.request.query_params,
      pathParameters: struct.request.path_params
    }
  end

  defp headers(struct = %Struct{}) do
    struct
    |> base_headers()
    |> put_user_session_headers(struct.user_session)
    |> put_feature_header(struct.private)
    |> put_mvt_headers(struct.private)
  end

  defp base_headers(%Struct{request: request = %Request{}, private: private = %Private{}}) do
    %{
      country: request.country,
      language: request.language,
      "accept-encoding": "gzip",
      is_uk: request.is_uk,
      host: request.host,
      "ctx-route-spec": private.route_state_id
    }
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
      value = private.features |> Enum.map(&Tuple.to_list/1) |> Enum.map(&Enum.join(&1, "=")) |> Enum.join(",")
      Map.put(headers, :"ctx-features", value)
    end
  end

  defp put_mvt_headers(headers, private = %Private{}) do
    if private.mvt == %{} do
      headers
    else
      Enum.reduce(private.mvt, headers, fn {k, {_, v}}, h -> Map.put(h, k, v) end)
    end
  end
end
