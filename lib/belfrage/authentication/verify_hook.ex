defmodule Belfrage.Authentication.VerifyHook do
  use Joken.Hooks

  @impl true
  def before_verify(_options, {jwt, %Joken.Signer{} = _signer}) do
    with {:ok, header} <- Joken.peek_header(jwt),
         {:ok, algorithm, key} <- public_key(header) do
      {:cont, {jwt, Joken.Signer.create(algorithm, key)}}
    else
      {:error, :token_malformed} ->
        {:halt, {:error, :token_malformed}}

      {:error, :invalid_token_header} ->
        {:halt, {:error, :invalid_token_header}}

      {:error, :public_key_not_found} ->
        {:halt, {:error, :public_key_not_found}}
    end
  end

  defp public_key(%{"kid" => kid, "alg" => alg, "typ" => "JWT"}) do
    Belfrage.Authentication.Jwk.get_key(alg, kid)
  end

  defp public_key(_header), do: {:error, :invalid_token_header}
end