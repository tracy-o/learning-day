defmodule Belfrage.Helpers.QueryParams do
  alias Plug.Conn.Query
  def encode(map) when map == %{}, do: ""

  def encode(map), do: "?" <> Query.encode(map)
end
