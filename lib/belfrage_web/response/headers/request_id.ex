defmodule BelfrageWeb.Response.Headers.RequestId do
  import Plug.Conn
  alias Belfrage.Envelope

  @behaviour BelfrageWeb.Response.Headers.Behaviour

  @impl true
  def add_header(conn, %Envelope{request: %Envelope.Request{request_id: request_id}}) when is_binary(request_id) do
    put_resp_header(conn, "brequestid", request_id)
  end

  def add_header(conn, _envelope) do
    conn
  end
end
