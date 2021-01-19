defmodule Belfrage.Authentication.Validator do
  use Joken.Config, default_signer: nil

  alias __MODULE__

  add_hook(Belfrage.Authentication.VerifyHook)

  @impl Joken.Config
  def token_config do
    default_claims(skip: [:aud, :iss])
    |> add_claim("aud", nil, &(&1 == auth_config()["aud"]))
    |> add_claim("tokenName", nil, &(&1 == "access_token"))
    |> Map.put("iss", %Joken.Claim{generate: nil, validate: &is_valid_issuer?/3})
  end

  defp is_valid_issuer?(_issuer_in_claim, claims, _) do
    Validator.Issuer.valid?(auth_config()["iss"], claims)
  end

  defp auth_config do
    Application.get_env(:belfrage, :authentication)
  end
end
