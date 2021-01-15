defmodule Belfrage.Authentication.Validator.Issuer do
  def valid?(base_issuer, %{"iss" => issuer_in_claim, "realm" => realm}) do
    with_trailing_issuer_realm(base_issuer, realm) == issuer_in_claim
  end

  def valid?(_base_issuer, _claims), do: false

  defp with_trailing_issuer_realm(issuer, _realm = "/"), do: issuer

  defp with_trailing_issuer_realm(issuer, realm), do: Path.join(issuer, realm)
end
