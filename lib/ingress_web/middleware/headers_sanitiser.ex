defmodule IngressWeb.Middleware.HeadersSanitiser do
  def init(opts), do: opts

  def call(conn, _opts) do
    # Do some logic, and put header values inside conn.private
    # using https://hexdocs.pm/plug/Plug.Conn.html#put_private/3
    # Then inside `struct_adapter.ex` we can take the values out
    # of conn.private and add it to the struct.
    conn
  end
end
