defmodule Belfrage.Services.Webcore.Request do
  alias Belfrage.Struct
  alias Belfrage.Services.Webcore.Helpers.Utf8Sanitiser

  def build(struct) do
    %{
      headers: headers(struct),
      body: struct.request.payload,
      httpMethod: struct.request.method,
      path: struct.request.path,
      queryStringParameters: Utf8Sanitiser.utf8_sanitise_query_params(struct.request.query_params),
      pathParameters: struct.request.path_params
    }
  end

  defp headers(
         struct = %Struct{
           private: %Struct.Private{
             authenticated: true,
             session_token: session_token,
             valid_session: true
           }
         }
       )
       when is_binary(session_token) do
    struct
    |> base_headers()
    |> Map.put(:authorization, "Bearer #{session_token}")
    |> Map.put(:"x-authentication-provider", "idv5")
    |> Map.put(:"pers-env", authentication_environment)
    |> maybe_put_user_attributes_headers(struct.private.user_attributes)
  end

  defp headers(struct), do: base_headers(struct)

  defp base_headers(struct) do
    %{
      country: struct.request.country,
      language: struct.request.language,
      "accept-encoding": "gzip",
      is_uk: struct.request.is_uk,
      host: struct.request.host
    }
  end

  # This still doesn't cover partial presence of attributes
  # that will be covered by RESFRAME-4284
  defp maybe_put_user_attributes_headers(
         base_headers,
         _user_attributes = %{age_bracket: age_bracket, allow_personalisation: allow_personalisation}
       ) do
    base_headers
    |> Map.put(:"ctx-age-bracket", age_bracket)
    |> Map.put(:"ctx-allow-personalisation", to_string(allow_personalisation))
  end

  defp maybe_put_user_attributes_headers(base_headers, _user_attributes) do
    base_headers
  end

  defp authentication_environment do
    Application.get_env(:belfrage, :authentication)["account_jwk_uri"] |> extract_env()
  end

  def extract_env("https://access.api.bbc.com/v1/oauth/connect/jwk_uri"), do: "live"
  def extract_env("https://access.test.api.bbc.com/v1/oauth/connect/jwk_uri"), do: "test"
  def extract_env("https://access.stage.api.bbc.com/v1/oauth/connect/jwk_uri"), do: "stage"
  def extract_env("https://access.int.api.bbc.com/v1/oauth/connect/jwk_uri"), do: "int"
  def extract_env(_uri), do: raise("No JWK Account URI found, please check Cosmos config")
end
