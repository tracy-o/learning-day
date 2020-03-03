defmodule Belfrage.Helpers.QueryParams do
  alias Plug.Conn.Query
  def parse(map) when map == %{}, do: ""

  def parse(map), do: "?" <> Query.encode(map)
end
