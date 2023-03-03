defmodule Belfrage.Logger.Formatter do
  require Logger

  def app(level, message, timestamp, metadata) do
    case Keyword.get(metadata, :cloudwatch) do
      true ->
        ""

      _ ->
        format(level, message, timestamp, metadata)
    end
  end

  def cloudwatch(level, message, timestamp, metadata) do
    case Keyword.get(metadata, :cloudwatch) do
      true ->
        format(level, message, timestamp, metadata)

      _ ->
        ""
    end
  end

  def access(level, message, timestamp, metadata) do
    case Keyword.get(metadata, :access) do
      true ->
        gtm_format(level, message, timestamp, metadata)

      _ ->
        ""
    end
  end

  def format(level, message, timestamp, metadata) do
    [
      Json.encode!(
        Map.merge(
          %{
            # This is what stump was doing
            datetime: DateTime.utc_now() |> DateTime.to_iso8601(),
            level: level,
            # TODO The old logs would sometimes put things under the "metadata" key, and sometimes at the top-level.
            metadata: %{},
            # TODO sometimes we used "msg" and sometimes "message" when logging with Stump, pick one.
            message: :erlang.iolist_to_binary(message)
          },
          to_json(Map.new(take_metadata(metadata)))
        )
      ),
      "\n"
    ]
  rescue
    _ -> "could not format message: #{inspect({level, message, timestamp, metadata})}\n"
  end

  @spec gtm_format(any, any, {any, {any, any, any, any}}, any) :: <<_::64, _::_*8>> | [nonempty_binary, ...]
  def gtm_format(level, _message, time_tuple = {date_erl, {h, m, s, ms}}, metadata) do
    timestamp =
      NaiveDateTime.from_erl!({date_erl, {h, m, s}}, ms)
      |> DateTime.from_naive!("Etc/UTC")
      |> DateTime.to_iso8601()
      |> with_quote()

    method = Keyword.get(metadata, :method) |> with_quote()
    request_path = Keyword.get(metadata, :request_path) |> with_quote()
    query_string = Keyword.get(metadata, :query_string) |> with_quote()
    status = Keyword.get(metadata, :status) |> with_quote()
    bbc_request_id = Keyword.get(metadata, :bbc_request_id) |> with_quote()
    req_svc_chain = Keyword.get(metadata, :req_svc_chain) |> with_quote()
    scheme = Keyword.get(metadata, :scheme) |> with_quote()
    host = Keyword.get(metadata, :host) |> with_quote()
    bsig = Keyword.get(metadata, :bsig) |> with_quote()
    belfrage_cache_status = Keyword.get(metadata, :belfrage_cache_status) |> with_quote()
    cache_control = Keyword.get(metadata, :cache_control) |> with_quote()
    content_length = Keyword.get(metadata, :content_length) |> with_quote()
    bid = Keyword.get(metadata, :bid) |> with_quote()
    location = Keyword.get(metadata, :location) |> with_quote()
    vary = Keyword.get(metadata, :vary) |> with_quote()

    [
      Enum.join(
        [
          timestamp,
          bbc_request_id,
          scheme,
          host,
          method,
          request_path,
          query_string,
          status,
          bsig,
          belfrage_cache_status,
          cache_control,
          content_length,
          bid,
          location,
          req_svc_chain,
          vary
        ],
        " "
      ) <>
        "\n"
    ]
  rescue
    e ->
      "could not format message: #{inspect({level, "", time_tuple, metadata})}, error: #{inspect(e)}\n"
  end

  defp take_metadata(metadata) do
    # TODO omitting for match previous behaviour. It would be useful to log some of these in the future.
    Keyword.drop(metadata, [
      :erl_level,
      :time,
      :application,
      :file,
      :line,
      :function,
      :module,
      :domain,
      :gl,
      :pid,
      :mfa,
      :cloudwatch,
      :crash_reason
    ])
  end

  defp to_json(val = %{__struct__: _}) do
    to_json(Map.from_struct(val))
  end

  defp to_json(val) when is_map(val) do
    Enum.reduce(val, %{}, fn
      {k, val}, acc -> Map.put(acc, to_string(k), to_json(val))
    end)
  end

  defp to_json(val) when is_atom(val) do
    val
  end

  defp to_json(val) when is_binary(val) do
    val
  end

  defp to_json(val) when is_tuple(val) do
    Tuple.to_list(val)
    |> to_json()
  end

  defp to_json(val) when is_list(val) do
    Enum.map(val, &to_json/1)
  end

  defp to_json(val) do
    inspect(val)
  end

  defp with_quote(value) do
    "\"#{value}\""
  end
end
