defmodule BelfrageWeb.StructAdapter do
  alias Belfrage.Struct
  alias Belfrage.Struct.{Request, Private}
  alias Plug.Conn
  import Plug.Conn

  @query_string_allowlist ["query", "operationName", "variables", "extensions"]

  def adapt(conn = %Conn{private: %{loop_id: loop_id, bbc_headers: bbc_headers}}) do
    %Struct{
      request: %Request{
        path: conn.request_path,
        payload: body(conn),
        method: conn.method,
        country: bbc_headers.country,
        query_params: query_string(conn),
        has_been_replayed?: bbc_headers.replayed_traffic
      },
      private: %Private{
        loop_id: loop_id
      }
    }
  end

  def adapt(conn = %Conn{}) do
    conn
    |> put_private(:loop_id, conn.path_info |> Enum.take(2))
    |> adapt()
  end

  defp query_string(conn) do
    Plug.Conn.Query.decode(conn.query_string)
    |> Map.take(@query_string_allowlist)
  end

  defp body(conn) do
    case read_body(conn) do
      {:ok, body, _conn} -> body
      _ -> nil
    end
  end
end
