defmodule BelfrageWeb.StructAdapter do
  alias Belfrage.Struct
  alias Belfrage.Struct.{Request, Private}
  alias Plug.Conn
  import Plug.Conn

  def adapt(conn = %Conn{private: %{bbc_headers: bbc_headers}}, loop_id) do
    %Struct{
      request: %Request{
        path: conn.request_path,
        payload: body(conn),
        method: conn.method,
        country: bbc_headers.country,
        path_params: conn.path_params,
        query_params: query_string(conn),
        scheme: bbc_headers.scheme,
        host: bbc_headers.host,
        has_been_replayed?: bbc_headers.replayed_traffic,
        subdomain: subdomain(conn),
        varnish?: bbc_headers.varnish,
        edge_cache?: bbc_headers.cache,
        playground?: bbc_headers.playground
      },
      private: %Private{
        loop_id: loop_id
      }
    }
  end

  defp query_string(conn) do
    Plug.Conn.Query.decode(conn.query_string)
  end

  defp body(conn) do
    case read_body(conn) do
      {:ok, body, _conn} -> body
      _ -> nil
    end
  end

  defp subdomain(%Plug.Conn{host: host}) when bit_size(host) > 0 do
    host
    |> String.split(".")
    |> List.first()
  end

  defp subdomain(_conn), do: "www"
end
