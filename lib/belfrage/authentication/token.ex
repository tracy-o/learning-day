defmodule Belfrage.Authentication.Token do
  def parse(cookie) do
    case decode(cookie) do
      {:ok, token} ->
        extract_user_attributes(token)

      {:error, error} ->
        handle_decoding_error(error)
        {false, %{}}
    end
  end

  defp decode(cookie) do
    Belfrage.Authentication.Validator.verify_and_validate(cookie)
  end

  defp extract_user_attributes(decoded_token) do
    case decoded_token["userAttributes"] do
      %{"ageBracket" => age_bracket, "allowPersonalisation" => allow_personalisation} ->
        {true, %{age_bracket: age_bracket, allow_personalisation: allow_personalisation}}

      _ ->
        {true, %{}}
    end
  end

  defp handle_decoding_error(message: message, claim: claim, claim_val: claim_val) do
    Belfrage.Event.record(:log, :warn, %{
      msg: "Claim validation failed",
      message: message,
      claim_val: claim_val,
      claim: claim
    })
  end

  defp handle_decoding_error(:token_malformed) do
    Belfrage.Event.record(:log, :error, "Malformed JWT")
  end

  defp handle_decoding_error(:invalid_token_header) do
    Belfrage.Event.record(:log, :error, "Invalid token header")
  end

  defp handle_decoding_error(:public_key_not_found), do: :noop

  defp handle_decoding_error(:signature_error), do: :noop

  defp handle_decoding_error(_) do
    Belfrage.Event.record(:log, :error, "Unexpected token error.")
  end
end
