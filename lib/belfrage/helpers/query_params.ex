defmodule Belfrage.Helpers.QueryParams do
  alias Plug.Conn.Query

  def encode(map, encode \\ :not_encoded)

  def encode(map, _encode) when map == %{}, do: ""

  def encode(map, :not_encoded), do: "?" <> Query.encode(map)

  def encode(map, :encoded), do: "%3F" <> Query.encode(map)
end
