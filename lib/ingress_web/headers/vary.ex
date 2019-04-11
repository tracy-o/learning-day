defmodule IngressWeb.Headers.Vary do
  alias IngressWeb.Behaviours.Headers

  @behaviour Headers

  @impl Headers

  def add_header(conn, struct) do
    conn
  end
end
