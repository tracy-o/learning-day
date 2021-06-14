defmodule Belfrage.Authentication.Token do
  def parse(cookie) do
    cookie
    |> decode()
    |> validate()
    |> get_attributes()
  end

  defp decode(nil) do
    nil
  end

  defp decode(cookie) do
    Belfrage.Authentication.Validator.verify_and_validate(cookie)
  end

  defp get_attributes({true, _decoded_token}) do
    user_attributes = 123
    {true, user_attributes}
  end

  defp get_attributes(_) do
    {false, nil}
  end

  defp validate(_decoded_token = nil), do: false

  defp validate({:ok, decoded_token}) do
    {true, decoded_token}
  end

  defp validate({:error, [message: message, claim: claim, claim_val: claim_val]}) do
    Belfrage.Event.record(:log, :warn, %{
      msg: "Claim validation failed",
      message: message,
      claim_val: claim_val,
      claim: claim
    })

    false
  end

  defp validate({:error, :token_malformed}) do
    Belfrage.Event.record(:log, :error, "Malformed JWT")

    false
  end

  defp validate({:error, :public_key_not_found}) do
    false
  end

  defp validate({:error, :invalid_token_header}) do
    Belfrage.Event.record(:log, :error, "Invalid token header")

    false
  end

  defp validate({:error, :signature_error}) do
    false
  end

  defp validate({:error, _}) do
    Belfrage.Event.record(:log, :error, "Unexpected token error.")

    false
  end
end
