defmodule Belfrage.Transformers.UserSession do
  use Belfrage.Transformers.Transformer
  import Plug.Conn.Cookies, only: [decode: 1]

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{raw_headers: %{"cookie" => cookie}}}) do
    then(rest, Struct.add(struct, :private, %{authenticated: authenticated?(cookie)}))
  end

  def call(rest, struct) do
    then(rest, struct)
  end

  defp authenticated?(cookie), do: decode(cookie) |> Map.has_key?("ckns_id")
end
