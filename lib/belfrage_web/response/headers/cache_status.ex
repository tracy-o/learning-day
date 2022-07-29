defmodule BelfrageWeb.Response.Headers.CacheStatus do
  import Plug.Conn
  alias Belfrage.Struct

  @behaviour BelfrageWeb.Response.Headers.Behaviour

  @impl true
  def add_header(conn, %Struct{response: %Struct.Response{fallback: true}}) do
    put_resp_header(conn, "belfrage-cache-status", "STALE")
    |> put_resp_header("warning", "111")
  end

  @impl true
  def add_header(conn, %Struct{private: %Struct.Private{origin: :belfrage_cache}}) do
    put_resp_header(conn, "belfrage-cache-status", "HIT")
  end

  def add_header(conn, _struct) do
    put_resp_header(conn, "belfrage-cache-status", "MISS")
  end
end
