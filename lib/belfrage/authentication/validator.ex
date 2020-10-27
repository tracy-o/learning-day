defmodule Belfrage.Authentication.Validator do
  def valid?(token) do
    # @todo: Get the JDK data
    %{header: header} = decode(token)
    public_key = get_matching_key(header)
    validated_token = verify(token, header)
  end

  def token(token) do
  end

  def jwk_data do
    # @todo: get keys and return one
    Belfrage.Authentication.Jwk.get_keys()
  end

  defp get_matching_key(%{alg: alg, kid: id}) do
    # @todo: filter jwk data and select matching key algorithm
  end

  defp decode(token) do
    token
    |> Joken.token
    # |> Joken.with_validation("exp", &(&1 > Joken.current_time()))
  end

  defp verify(token, public_key) do
    token
    |> Joken.with_validation("exp", &(&1 > Joken.current_time()))
    |> Joken.with_signer(signer(public_key))
    |> Joken.verify
  end
end
