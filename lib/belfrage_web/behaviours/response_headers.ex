defmodule BelfrageWeb.Behaviours.ResponseHeaders do
  alias Belfrage.Struct
  @callback add_header(Plug.Conn.t(), Struct.t()) :: Plug.Conn.t()
end
