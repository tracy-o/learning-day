defmodule BelfrageWeb.Response.Headers.Behaviour do
  alias Belfrage.Envelope
  @callback add_header(Plug.Conn.t(), Envelope.t()) :: Plug.Conn.t()
end
