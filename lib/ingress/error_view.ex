defmodule Ingress.ErrorView do
  import Plug.Conn

  def render(conn, 404) do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(404, "Not Found")
  end
end
