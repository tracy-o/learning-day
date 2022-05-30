defmodule Belfrage.Authentication.Validator do
  use Joken.Config, default_signer: nil

  add_hook(Belfrage.Authentication.VerifyHook)

  @expiry_validator Application.get_env(:belfrage, :expiry_validator)

  @impl Joken.Config
  def token_config do
    default_claims(skip: [:aud, :iss, :exp])
    |> add_claim("tokenName", nil, &(&1 == "access_token"))
    |> add_claim("exp", nil, &is_valid_expiry?/1)
  end

  defp is_valid_expiry?(expiry) do
    auth_config = Application.get_env(:belfrage, :authentication)

    @expiry_validator.valid?(auth_config["jwt_expiry_window"], expiry)
  end
end
