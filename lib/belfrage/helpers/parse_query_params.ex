defmodule Belfrage.Helpers.QueryParams do
  def parse(map) when map == %{}, do: ""

  def parse(map), do: "?" <> URI.encode_query(map)
end
