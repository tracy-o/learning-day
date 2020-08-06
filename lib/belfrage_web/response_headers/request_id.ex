defmodule BelfrageWeb.ResponseHeaders.RequestId do
  import Plug.Conn
  alias Belfrage.Struct
  alias BelfrageWeb.Behaviours.ResponseHeaders

  @behaviour ResponseHeaders

  @impl ResponseHeaders
  def add_header(conn, %Struct{request: %Struct.Request{request_id: request_id}}) when is_binary(request_id) do
    put_resp_header(conn, "brequestid", request_id)
  end

  def add_header(conn, _struct) do
    conn
  end
end
