defmodule BelfrageWeb.StructAdapter do
  alias Belfrage.Struct
  alias Belfrage.Struct.{Request, Private}
  alias Plug.Conn
  import Plug.Conn

  def adapt(conn = %Conn{private: %{xray_trace_id: xray_trace_id, bbc_headers: bbc_headers}}, loop_id) do
    %Struct{
      request: %Request{
        path: conn.request_path,
        payload: body(conn),
        raw_headers: raw_headers(conn),
        method: conn.method,
        country: bbc_headers.country,
        path_params: conn.path_params,
        query_params: conn.query_params,
        scheme: bbc_headers.scheme,
        host: bbc_headers.host || conn.host,
        has_been_replayed?: bbc_headers.replayed_traffic,
        subdomain: subdomain(conn),
        varnish?: bbc_headers.varnish,
        edge_cache?: bbc_headers.cache,
        cdn?: bbc_headers.cdn,
        xray_trace_id: xray_trace_id,
        accept_encoding: accept_encoding(conn),
        is_uk: bbc_headers.is_uk
      },
      private: %Private{
        loop_id: loop_id,
        overrides: conn.private.overrides,
        production_environment: conn.private.production_environment,
        preview_mode: conn.private.preview_mode
      }
    }
  end

  defp body(conn) do
    case read_body(conn) do
      {:ok, body, _conn} -> body
      _ -> nil
    end
  end

  defp raw_headers(conn), do: Enum.into(conn.req_headers, %{})

  defp subdomain(%Plug.Conn{host: host}) when bit_size(host) > 0 do
    host
    |> String.split(".")
    |> List.first()
  end

  defp subdomain(_conn), do: "www"

  defp accept_encoding(conn) do
    case Plug.Conn.get_req_header(conn, "accept-encoding") do
      [accept_encoding] -> accept_encoding
      [] -> nil
    end
  end
end
