defmodule Belfrage.Transformers.UserSession do
  use Belfrage.Transformers.Transformer

  # note: `Plug.Conn.Cookies.decode` benchmark
  # https://github.com/bbc/belfrage/pull/574#issuecomment-715417312
  import Plug.Conn.Cookies, only: [decode: 1]

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{raw_headers: %{"cookie" => cookie}}}) do
    struct = %{struct | private: handle_cookies(decode(cookie), struct.private)}
    struct = %{struct | private: valid?(struct.private)}
    then(rest, struct)
  end

  def call(rest, struct), do: then(rest, struct)

  defp valid?(%Struct.Private{session_token: nil} = struct) do
    %{struct | valid_session: false}
  end

  defp valid?(%Struct.Private{authenticated: true, session_token: token} = struct) do
    case Belfrage.Authentication.Validator.verify_and_validate(token) do
      {:ok, _decoded_token} -> %{struct | valid_session: true}
      {_, _} -> %{struct | valid_session: false}
    end
  end

  defp valid?(struct), do: struct

  defp handle_cookies(decoded_cookies, private_struct)

  defp handle_cookies(%{"ckns_id" => _, "ckns_atkn" => token}, struct) do
    %{struct | authenticated: true, session_token: token}
  end

  defp handle_cookies(%{"ckns_id" => _}, struct), do: %{struct | authenticated: true}
  defp handle_cookies(_cookies, struct), do: struct
end
