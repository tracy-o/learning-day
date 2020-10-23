defmodule Belfrage.Transformers.UserSession do
  use Belfrage.Transformers.Transformer
  import Plug.Conn.Cookies, only: [decode: 1]

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{raw_headers: %{"cookie" => cookie}}}) do
    then(rest, %{struct | private: handle_cookies(decode(cookie), struct.private)})
  end

  def call(rest, struct), do: then(rest, struct)

  defp handle_cookies(decoded_cookies, private_struct)

  defp handle_cookies(%{"ckns_id" => _, "ckns_atkn" => _}, struct) do
    %{struct | authenticated: true, session_token: true}
  end

  defp handle_cookies(%{"ckns_id" => _}, struct), do: %{struct | authenticated: true}
  defp handle_cookies(_cookies, struct), do: struct
end
