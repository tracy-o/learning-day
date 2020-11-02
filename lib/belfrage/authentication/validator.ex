defmodule Belfrage.Authentication.Validator do
  use Joken.Config, default_signer: nil

  add_hook(Belfrage.Authentication.VerifyHook)

  @impl Joken.Config
  def token_config do
    default_claims(skip: [:aud, :iss])
    |> add_claim("iss", nil, &(&1 == auth_config()["iss"]))
    |> add_claim("aud", nil, &(&1 == auth_config()["aud"]))
    |> add_claim("tokenName", nil, &(&1 == "access_token"))
  end

  defp auth_config do
    Application.get_env(:belfrage, :authentication)
  end
end
