defmodule Belfrage.Authentication.Token do
  require Logger
  alias Belfrage.Metrics

  def parse(cookie) do
    Metrics.latency_span(:parse_session_token, fn ->
      case decode(cookie) do
        {:ok, token} ->
          extract_user_attributes(token)

        {:error, error} ->
          handle_decoding_error(error)
          {false, %{}}
      end
    end)
  end

  defp decode(cookie) do
    Belfrage.Authentication.Validator.verify_and_validate(cookie)
  end

  defp extract_user_attributes(decoded_token)
       when is_map_key(decoded_token, "profileAdminId") and
              is_map_key(decoded_token, "userAttributes") do
    {true,
     %{
       age_bracket: get_in(decoded_token, ["userAttributes", "ageBracket"]),
       allow_personalisation: get_in(decoded_token, ["userAttributes", "allowPersonalisation"]),
       profile_admin_id: decoded_token["profileAdminId"]
     }}
  end

  defp extract_user_attributes(decoded_token) when is_map_key(decoded_token, "userAttributes") do
    {true,
     %{
       age_bracket: get_in(decoded_token, ["userAttributes", "ageBracket"]),
       allow_personalisation: get_in(decoded_token, ["userAttributes", "allowPersonalisation"])
     }}
  end

  defp extract_user_attributes(_decoded_token), do: {true, %{}}

  defp handle_decoding_error(message: message, claim: claim, claim_val: claim_val) do
    Logger.log(:warn, message, %{
      msg: "Claim validation failed",
      claim_val: claim_val,
      claim: claim
    })
  end

  defp handle_decoding_error(:token_malformed) do
    Logger.log(:error, "Malformed JWT")
  end

  defp handle_decoding_error(:invalid_token_header) do
    Logger.log(:error, "Invalid token header")
  end

  defp handle_decoding_error(:public_key_not_found), do: :noop

  defp handle_decoding_error(:signature_error), do: :noop

  defp handle_decoding_error(_) do
    Logger.log(:error, "Unexpected token error.")
  end
end
