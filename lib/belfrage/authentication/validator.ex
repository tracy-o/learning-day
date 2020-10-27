defmodule Belfrage.Authentication.Validator do
  use Joken.Config, default_signer: nil

  add_hook(Belfrage.Authentication.VerifyHook)

  @authentication Application.get_env(:belfrage, :authentication)

  @impl Joken.Config
  def token_config do
    default_claims(skip: [:aud, :iss])
    |> add_claim("iss", nil, &(&1 == @authentication["iss"]))
    |> add_claim("aud", nil, &(&1 == @authentication["aud"]))
    |> add_claim("tokenName", nil, &(&1 == "access_token"))
  end
end
