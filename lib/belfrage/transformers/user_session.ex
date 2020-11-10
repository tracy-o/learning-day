defmodule Belfrage.Transformers.UserSession do
  use Belfrage.Transformers.Transformer

  # note: `Plug.Conn.Cookies.decode` benchmark
  # https://github.com/bbc/belfrage/pull/574#issuecomment-715417312
  import Plug.Conn.Cookies, only: [decode: 1]

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{raw_headers: %{"cookie" => cookie}}}) do
    struct = %{struct | private: handle_cookies(decode(cookie), struct.private) |> valid?()}
    then(rest, struct)
  end

  def call(rest, struct), do: then(rest, struct)

  defp valid?(private_struct = %Struct.Private{session_token: nil}) do
    %{private_struct | valid_session: false}
  end

  defp valid?(private_struct = %Struct.Private{authenticated: true, session_token: token}) do
    case Belfrage.Authentication.Validator.verify_and_validate(token) do
      {:ok, _decoded_token} ->
        %{private_struct | valid_session: true}

      {:error, [message: message, claim: claim, claim_val: claim_val]} ->
        Belfrage.Event.record(:log, :warn, %{
          msg: "Claim validation failed",
          message: message,
          claim_val: claim_val,
          claim: claim
        })

        %{private_struct | valid_session: false}

      {:error, :token_malformed} ->
        Belfrage.Event.record(:log, :error, "Malformed JWT")
        %{private_struct | valid_session: false}

      {:error, :public_key_not_found} ->
        %{private_struct | valid_session: false}

      {:error, :invalid_token_header} ->
        Belfrage.Event.record(:log, :error, "Invalid token header")
        %{private_struct | valid_session: false}

      {:error, :signature_error} ->
        %{private_struct | valid_session: false}

      {:error, _} ->
        Belfrage.Event.record(:log, :error, "Unexpected token error.")
        %{private_struct | valid_session: false}
    end
  end

  defp valid?(private_struct), do: private_struct

  defp handle_cookies(decoded_cookies, private_struct)

  defp handle_cookies(%{"ckns_id" => _, "ckns_atkn" => token}, private_struct) do
    %{private_struct | authenticated: true, session_token: token}
  end

  defp handle_cookies(%{"ckns_id" => _}, private_struct), do: %{private_struct | authenticated: true}
  defp handle_cookies(_cookies, private_struct), do: private_struct
end
