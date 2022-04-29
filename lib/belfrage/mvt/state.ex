defmodule Belfrage.Mvt.State do
  alias Belfrage.Struct

  def put_mvt_vary_headers(seen_headers, headers) do
    now = DateTime.utc_now()
    Enum.reduce(headers, seen_headers, fn h, acc -> Keyword.put(acc, String.to_atom(h), now) end)
  end

  def get_vary_headers(struct = %Struct{}) do
    struct.response.headers
    |> Map.get("vary", "")
    |> String.split(",", trim: true)
    |> Enum.filter(&mvt_header?/1)
  end

  defp mvt_header?(header) do
    match?(<<"mvt-", _name::binary>>, header)
  end
end
