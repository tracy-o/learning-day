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
    # Get the keys from the GenServer and then filter to get the matching key
    keys = Belfrage.Authentication.Jwk.get_keys()
    key = get_matching_key(keys, kid, alg)

    {:ok, alg, key}
  end

  defp get_matching_key(%{"keys" => keys}, _kid, _alg) do
    # @todo get the key using the kid + alg
    [key | rest] = keys
    key
  end
end
