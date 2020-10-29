defmodule Belfrage.Authentication.VerifyHook do
  use Joken.Hooks

  @impl true
  def before_verify(_options, {jwt, %Joken.Signer{} = _signer}) do
    with {:ok, header} <- Joken.peek_header(jwt),
         {:ok, algorithm, key} <- public_key(header) do
      {:cont, {jwt, Joken.Signer.create(algorithm, key)}}
    else
      :error -> {:halt, {:error, :no_signer}}
    end
  end

  defp public_key(%{"kid" => kid, "alg" => alg, "typ" => "JWT"}) do
    {:ok, alg, Belfrage.Authentication.Jwk.get_keys() |> key(kid, alg)}
  end

  defp public_key(_header), do: {:error, nil}

  defp key(%{"keys" => keys}, kid, alg) do
    Enum.find(keys, fn key -> key["kid"] == kid && key["alg"] == alg end)
  end
end
