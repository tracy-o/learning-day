defmodule Belfrage.Authentication.SessionState do
  alias Belfrage.Authentication.Token

  def build(cookies, headers, path) do
    token = cookies["ckns_atkn"]
    signed_in = cookies["ckns_id"] || headers["x-id-oidc-signedin"] == "1"

    cond do
      path == "/full-stack-test/a/ft" && token == "FAKETOKEN" ->
        build_fake_session(token)

      signed_in && token ->
        build_session(token)

      signed_in ->
        %{
          authentication_env: authentication_env(),
          session_token: nil,
          authenticated: true,
          valid_session: false,
          user_attributes: %{}
        }

      true ->
        %{
          authentication_env: authentication_env(),
          session_token: nil,
          valid_session: false,
          authenticated: false,
          user_attributes: %{}
        }
    end
  end

  defp build_fake_session(token) do
    %{
      authentication_env: authentication_env(),
      session_token: token,
      valid_session: true,
      authenticated: true,
      user_attributes: %{}
    }
  end

  defp build_session(token) do
    {valid_session?, user_attributes} = Token.parse(token)

    %{
      authentication_env: authentication_env(),
      session_token: token,
      authenticated: true,
      valid_session: valid_session?,
      user_attributes: user_attributes
    }
  end

  @environments %{
    "https://access.api.bbc.com/v1/oauth/connect/jwk_uri" => "live",
    "https://access.test.api.bbc.com/v1/oauth/connect/jwk_uri" => "test",
    "https://access.test.api.bbc.com/v1/oauth/connect/jwk_uri" => "stage",
    "https://access.int.api.bbc.com/v1/oauth/connect/jwk_uri" => "int"
  }

  defp authentication_env do
    url = Application.get_env(:belfrage, :authentication)["account_jwk_uri"]

    Map.get(@environments, url, fn _url ->
      raise "No JWK Account URI found, please check Cosmos config"
    end)
  end
end
