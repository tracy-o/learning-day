defmodule IngressWeb.StructAdapter do
  alias Ingress.Struct
  alias Ingress.Struct.{Request, Private}
  alias Plug.Conn
  import Plug.Conn

  def adapt(conn = %Conn{private: %{loop_id: loop_id, bbc_headers: bbc_headers}}) do
    %Struct{
      request: %Request{
        path: conn.request_path,
        payload: body(conn),
        method: conn.method,
        country: bbc_headers.country
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

  defp body(conn) do
    case read_body(conn) do
      {:ok, body, _conn} -> body
      _ -> nil
    end
  end
end
