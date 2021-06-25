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
          authentication_environment: authentication_environment(),
          session_token: nil,
          authenticated: true,
          valid_session: false,
          user_attributes: %{}
        }

      true ->
        %{
          authentication_environment: authentication_environment(),
          session_token: nil,
          valid_session: false,
          authenticated: false,
          user_attributes: %{}
        }
    end
  end

  defp build_fake_session(token) do
    %{
      authentication_environment: authentication_environment(),
      session_token: token,
      valid_session: true,
      authenticated: true,
      user_attributes: %{}
    }
  end

  defp build_session(token) do
    {valid_session?, user_attributes} = Token.parse(token)

    %{
      authentication_environment: authentication_environment(),
      session_token: token,
      authenticated: true,
      valid_session: valid_session?,
      user_attributes: user_attributes
    }
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
