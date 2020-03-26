defmodule BelfrageWeb.ResponseHeaders.Fallback do
  import Plug.Conn
  alias Belfrage.Struct
  alias BelfrageWeb.Behaviours.ResponseHeaders

  @behaviour ResponseHeaders

  @impl ResponseHeaders
  def add_header(conn, %Struct{response: %Struct.Response{fallback: true}}) do
    put_resp_header(conn, "bfa", "1")
  end

  def add_header(conn, _struct) do
    conn
  end
end
