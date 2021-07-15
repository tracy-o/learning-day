defmodule Belfrage.Authentication.SessionState do
  alias Belfrage.Struct.Request
  alias Belfrage.Authentication.Token

  def authenticated?(request = %Request{}) do
    request.cookies["ckns_id"] || request.raw_headers["x-id-oidc-signedin"] == "1"
  end

  def build(request = %Request{}) do
    token = request.cookies["ckns_atkn"]
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
end
