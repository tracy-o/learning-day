defmodule Belfrage.Mvt.State do
  alias Belfrage.Struct

  @doc """
  Updates a Map of 'seen' headers with new headers.
  The keys in the Map are the headers, and the values
  are datetimes. The new headers will be put into the
  Map as follows:

  A new header will be added to the Map as a key-value pair
  with the header as the key and a datetime as the value.
  If the header is already in the Map, the value of the
  corresponding key-value pair will be updated to a have a later datetime.
  """
  def put_mvt_vary_headers(seen_headers, headers) do
    now = DateTime.utc_now()
    Enum.reduce(headers, seen_headers, fn h, acc -> Map.put(acc, h, now) end)
  end

  @doc """
  Gets the MVT vary headers from the vary header in the Struct response.
  A list is returned.
  If there are no MVT vary headers, or there is no vary header,
  then an empty list is returned.
  """
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
