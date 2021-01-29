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
           private: %Struct.Private{authenticated: true, session_token: session_token, valid_session: true}
         }
       )
       when is_binary(session_token) do
    struct
    |> base_headers()
    |> Map.put(:authorization, "Bearer #{session_token}")
    |> Map.put(:"x-authentication-provider", "idv5")
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
end
