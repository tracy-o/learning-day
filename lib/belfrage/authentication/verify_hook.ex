defmodule Belfrage.Authentication.VerifyHook do
  use Joken.Hooks

  alias Belfrage.Authentication.Jwk

  @impl true
  def before_verify(_options, {jwt, %Joken.Signer{} = _signer}) do
    with {:ok, %{"kid" => kid, "alg" => alg}} <- Joken.peek_header(jwt),
         {:ok, algorithm, key} <- fetch_key(kid, alg) do
      {:cont, {jwt, Joken.Signer.create(algorithm, key)}}
    else
      error -> {:halt, {:error, :no_signer}}
    end
  end

  defp fetch_key(kid, alg) do
    keys = Belfrage.Authentication.Jwk.get_keys()
    # todo: check typ is JWT
    key = get_matching_key(keys, kid, alg)

    {:ok, alg, key}
  end

  defp get_matching_key(%{"keys" => keys}, kid, alg) do
    Enum.find(keys, fn key -> key["kid"] == kid && key["alg"] == alg end)
  end
end
