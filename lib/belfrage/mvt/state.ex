defmodule Belfrage.Mvt.State do
  alias Belfrage.{Struct, RouteState}

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
  Gets the MVT vary headers from the vary header in the Struct Response.
  A list is returned.
  If there are no MVT vary headers, or there is no vary header,
  then an empty list is returned.
  """
  def get_vary_headers(response = %Struct.Response{}) do
    response.headers
    |> Map.get("vary", "")
    |> String.split(",", trim: true)
    |> Enum.filter(&mvt_header?/1)
  end

  @doc """
  Removes any headers prefixed with \"bbc-mvt-\"
  with header value that does not match any
  headers in :mvt_seen in the state of the RouteState.

  For example, given the raw headers:

      %{"foo" => "bar",
        "bbc-mvt-1" => "experiment;button_colour;red",
        "bbc-mvt-2" => "experiment;sidebar_colour;red"}

  If we have the following headers in :mvt_seen in the
  RouteState process state given by route_state_id:

      %{"mvt-button_colour" => ~U[2022-05-20 12:25:30.420932Z]}

  The following map should be returned:

      %{"foo" => "bar",
        "bbc-mvt-1" => "experiment;button_colour;red"}
  """
  def filter_mvt_headers(headers, route_state_id) do
    seen_headers = get_seen_headers(route_state_id)

    :maps.filter(
      fn header, value ->
        not bbc_mvt_header?(header) or Enum.member?(seen_headers, prefixed_experiment(value))
      end,
      headers
    )
  end

  defp get_seen_headers(route_state_id) do
    case routestate_state(route_state_id) do
      {:ok, state} ->
        state
        |> Map.get(:mvt_seen)
        |> Map.keys()

      _ ->
        []
    end
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
    String.starts_with?(header, "mvt-")
  end

  defp bbc_mvt_header?(header) do
    String.starts_with?(header, "bbc-mvt-")
  end

  defp prefixed_experiment(v) do
    case String.split(v, ";", trim: true) do
      [_type, experiment, _variant] ->
        "mvt-" <> experiment

      _ ->
        :invalid_bbc_mvt_header_value_format
    end
  end

  # Checks if the dt datetime minus the baseline_dt datetime
  # is more than interval_ms, in seconds.
  defp expired?(dt, interval_ms, baseline_dt) do
    DateTime.diff(baseline_dt, dt, :second) > interval_ms / 1_000
  end

  # Similar to RouteState.state/1 but takes a route_state_id as the first argument,
  # and returns {:error, value} if the GenServer.call/3 fails rather than exiting the caller process.
  defp routestate_state(route_state_id, timeout \\ Application.get_env(:belfrage, :fetch_route_state_timeout)) do
    try do
      GenServer.call(RouteState.via_tuple(route_state_id), :state, timeout)
    catch
      :exit, value ->
        {:error, value}
    end
  end
end
