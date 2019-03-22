defmodule IngressWeb.StructAdapter do
  alias Ingress.Struct
  alias Ingress.Struct.{Request, Private}
  alias Plug.Conn
  import Plug.Conn

  def adapt(conn = %Conn{private: %{loop_id: _}}) do
    %Struct{
      request: %Request{
        path: conn.request_path,
        payload: conn.body_params
      },
      private: %Private{
        loop_id: conn.path_info |> Enum.take(2)
      }
    }
  end

  def adapt(conn = %Conn{}) do
    conn
    |> put_private(:loop_id, conn.path_info)
    |> adapt()
  end
end
