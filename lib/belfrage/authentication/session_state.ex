defmodule Belfrage.Authentication.SessionState do
  alias Belfrage.Envelope.Request
  alias Belfrage.Authentication.Token

  def authenticated?(request = %Request{}) do
    if request.app? do
      request.raw_headers["authorization"]
    else
      validate_sign_in(request)
    end
  end

  defp validate_sign_in(request) do
    case request.raw_headers["x-id-oidc-signedin"] do
      "0" -> false
      "1" -> true
      _ -> request.cookies["ckns_id"]
    end
  end

  def build(request = %Request{}) do
    token = get_token(request)
    authenticated = authenticated?(request)

    cond do
      request.path == "/full-stack-test/a/ft" && token == "FAKETOKEN" ->
        build_fake_session(token)

      authenticated && token ->
        build_session(token)

      authenticated ->
        build_invalid_session()

      true ->
        build_unauthenticated_session()
    end
  end

  defp build_fake_session(token) do
    %{
      authentication_env: authentication_env(account_url()),
      session_token: token,
      valid_session: true,
      authenticated: true,
      user_attributes: %{}
    }
  end

  defp build_session(token) do
    {valid_session?, user_attributes} = Token.parse(token)

    %{
      authentication_env: authentication_env(account_url()),
      session_token: token,
      authenticated: true,
      valid_session: valid_session?,
      user_attributes: user_attributes
    }
  end

  defp build_invalid_session() do
    %{
      authentication_env: authentication_env(account_url()),
      session_token: nil,
      authenticated: true,
      valid_session: false,
      user_attributes: %{}
    }
  end

  defp build_unauthenticated_session() do
    %{
      authentication_env: authentication_env(account_url()),
      session_token: nil,
      valid_session: false,
      authenticated: false,
      user_attributes: %{}
    }
  end

  @environments %{
    "https://access.api.bbc.com/v1/oauth/connect/jwk_uri" => "live",
    "https://access.stage.api.bbc.com/v1/oauth/connect/jwk_uri" => "stage",
    "https://access.test.api.bbc.com/v1/oauth/connect/jwk_uri" => "test",
    "https://access.int.api.bbc.com/v1/oauth/connect/jwk_uri" => "int"
  }

  def authentication_env(url) do
    Map.fetch!(@environments, url)
  end

  defp account_url do
    Application.get_env(:belfrage, :authentication)["account_jwk_uri"]
  end

  defp get_token(request = %Request{}) do
    if request.app? do
      request.raw_headers["authorization"]
      |> extract_token()
    else
      request.cookies["ckns_atkn"]
    end
  end

  defp extract_token(auth_header_value) do
    case auth_header_value do
      "Bearer " <> token -> token
      _ -> nil
    end
  end
end
