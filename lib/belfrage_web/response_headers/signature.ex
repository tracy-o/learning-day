defmodule BelfrageWeb.ResponseHeaders.Signature do
  import Plug.Conn

  alias Belfrage.Struct
  alias BelfrageWeb.Behaviours.ResponseHeaders

  @behaviour ResponseHeaders

  @impl ResponseHeaders
  def add_header(conn, %Struct{request: %Struct.Request{request_hash: request_hash}})
      when byte_size(request_hash) > 0 do
    put_resp_header(conn, "bsig", request_hash)
  end

  def add_header(conn, _struct) do
    conn
  end
end
