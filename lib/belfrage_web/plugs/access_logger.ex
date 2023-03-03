defmodule BelfrageWeb.Plugs.AccessLogger do
  require Logger
  alias Plug.Conn

  @behaviour Plug

  @req_allow_list [
    "x-bbc-request-id"
  ]

  @resp_allow_list [
    "bsig",
    "belfrage-cache-status",
    "cache-control",
    "content-length",
    "bid",
    "location",
    "vary",
    "req-svc-chain"
  ]

  @impl true
  def init(opts), do: Keyword.get(opts, :level, :info)

  @impl true
  def call(conn, level) do
    Conn.register_before_send(conn, fn conn ->
      %{
        method: method,
        request_path: request_path,
        query_string: query_string,
        status: status
      } = conn

      req_headers = filter(conn.req_headers, @req_allow_list)
      resp_headers = filter(conn.resp_headers, @resp_allow_list)

      bbc_headers = conn.private[:bbc_headers]

      scheme =
        case Map.get(bbc_headers, :scheme) do
          scheme when is_atom(scheme) -> scheme |> Atom.to_string()
          other -> to_string(other)
        end

      host = Map.get(bbc_headers, :host)
      bsig = Map.get(resp_headers, "bsig")
      belfrage_cache_status = Map.get(resp_headers, "belfrage-cache-status")
      cache_control = Map.get(resp_headers, "cache-control")
      content_length = Map.get(resp_headers, "content-length")
      bid = Map.get(resp_headers, "bid")
      location = Map.get(resp_headers, "location")
      vary = Map.get(resp_headers, "vary")
      req_svc_chain = Map.get(resp_headers, "req-svc-chain")
      bbc_request_id = Map.get(req_headers, "x-bbc-request-id")

      Logger.log(
        level,
        "",
        access: true,
        method: method,
        request_path: request_path,
        query_string: query_string,
        status: status,
        host: host,
        scheme: scheme,
        bsig: bsig,
        bbc_request_id: bbc_request_id,
        belfrage_cache_status: belfrage_cache_status,
        cache_control: cache_control,
        content_length: content_length,
        bid: bid,
        location: location,
        req_svc_chain: req_svc_chain,
        vary: vary
      )

      conn
    end)
  end

  defp filter(headers, allow_list) do
    {_, result} =
      headers
      |> Enum.map_reduce(%{}, fn {k, v}, acc ->
        if k in allow_list do
          {k, Map.update(acc, k, to_string(v), &(&1 <> "," <> to_string(v)))}
        else
          {k, acc}
        end
      end)

    result
  end
end
