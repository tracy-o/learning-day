defmodule IngressWeb.Behaviours.ResponseHeaders do
  alias Ingress.Struct
  @callback add_header(Plug.Conn.t(), Struct.t()) :: Plug.Conn.t()
end
