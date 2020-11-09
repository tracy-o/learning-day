defmodule Belfrage.Helpers.QueryParams do
  alias Plug.Conn.Query
  def encode(map, prefix \\ "?")

  def encode(map, prefix) when map == %{}, do: ""

  def encode(map, prefix), do: prefix <> Query.encode(map)
end
