defmodule BelfrageWeb.Response.Headers.Signature do
  import Plug.Conn

  alias Belfrage.Envelope

  @behaviour BelfrageWeb.Response.Headers.Behaviour

  @impl true
  def add_header(conn, %Envelope{request: %Envelope.Request{request_hash: request_hash}})
      when byte_size(request_hash) > 0 do
    put_resp_header(conn, "bsig", request_hash)
  end

  def add_header(conn, _envelope) do
    conn
  end
end
