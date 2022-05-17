defmodule Belfrage.Mvt.State do
  alias Belfrage.Struct

  @doc """
  Updates a Keyword list of 'seen' headers with new headers.
  The keys in the keyword list are the headers, and the values
  are datetimes. The new headers will be put into the
  keyword list as follows:

  A new header will be added to the Keyword list as a key-value pair
  with the header as the key and a datetime as the value.
  If the header is already in the Keyword list, the value of the
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

  @doc """
  seen_headers consist of header-datetime key-value pairs.
  Removes key-value pairs that have a datetime that are older
  than the UTC datetime now minus the given interval.
  """
  def prune_vary_headers(seen_headers, interval) do
    now = DateTime.utc_now()
    :maps.filter(fn _h, dt -> not expired?(dt, interval, now) end, seen_headers)
  end

  defp mvt_header?(header) do
    match?(<<"mvt-", _name::binary>>, header)
  end

  # Checks if the dt datetime minus the baseline_dt datetime
  # is more than interval_ms, in seconds.
  defp expired?(dt, interval_ms, baseline_dt) do
    DateTime.diff(baseline_dt, dt, :second) > interval_ms / 1_000
  end
end
