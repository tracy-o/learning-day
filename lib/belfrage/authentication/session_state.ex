defmodule Belfrage.Authentication.SessionState do
  alias Belfrage.Authentication.Token

  def add(
        %{"ckns_atkn" => "FAKETOKEN"},
        _headers,
        "/full-stack-test"
      ) do
    %{
      authentication_environment: authentication_environment(),
      session_token: "FAKETOKEN",
      authenticated: true,
      valid_session: true,
      user_attributes: %{}
    }
  end

  def add(
        %{"ckns_atkn" => ckns_atkn},
        %{"x-id-oidc-signedin" => "1"},
        _path
      )
      when is_binary(ckns_atkn) do
    {valid_session?, user_attributes} = Token.parse(ckns_atkn)

    %{
      authentication_environment: authentication_environment(),
      session_token: ckns_atkn,
      authenticated: true,
      valid_session: valid_session?,
      user_attributes: user_attributes
    }
  end

  def add(
        %{"ckns_atkn" => ckns_atkn, "ckns_id" => _id},
        _headers,
        _path
      )
      when is_binary(ckns_atkn) do
    {valid_session?, user_attributes} = Token.parse(ckns_atkn)

    %{
      authentication_environment: authentication_environment(),
      session_token: ckns_atkn,
      authenticated: true,
      valid_session: valid_session?,
      user_attributes: user_attributes
    }
  end

  def add(
        _cookies,
        %{"x-id-oidc-signedin" => "1"},
        _path
      ) do
        %{
          authentication_environment: authentication_environment(),
          session_token: nil,
          authenticated: true,
          valid_session: false,
          user_attributes: %{}
        }
  end

  def add(
        %{"ckns_id" => _id},
        _headers,
        _path
      ) do
    %{
      authentication_environment: authentication_environment(),
      session_token: nil,
      authenticated: true,
      valid_session: false,
      user_attributes: %{}
    }
  end

  def add(_cookies, _headers, _path) do
    %{
      authentication_environment: authentication_environment(),
      session_token: nil,
      authenticated: false,
      valid_session: false,
      user_attributes: %{}
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
