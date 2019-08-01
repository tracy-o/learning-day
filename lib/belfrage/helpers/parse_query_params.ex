defmodule Belfrage.Helpers.QueryParams do
  def parse(map) when is_map(map) do
    "?" <> URI.encode_query(map)
  end

  def parse(_) do
    ""
  end
end
