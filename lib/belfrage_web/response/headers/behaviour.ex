defmodule BelfrageWeb.Response.Headers.Behaviour do
  alias Belfrage.Struct
  @callback add_header(Plug.Conn.t(), Struct.t()) :: Plug.Conn.t()
end
