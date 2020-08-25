defmodule BelfrageWeb.ResponseHeaders.CacheStatus do
  import Plug.Conn
  alias Belfrage.Struct

  alias BelfrageWeb.Behaviours.ResponseHeaders

  @behaviour ResponseHeaders

  @impl ResponseHeaders
  def add_header(conn, %Struct{response: %Struct.Response{fallback: true}}) do
    put_resp_header(conn, "belfrage-cache-status", "STALE")
  end

  @impl ResponseHeaders
  def add_header(conn, %Struct{private: %Struct.Private{origin: :belfrage_cache}}) do
    put_resp_header(conn, "belfrage-cache-status", "HIT")
  end

  def add_header(conn, _struct) do
    put_resp_header(conn, "belfrage-cache-status", "MISS")
  end

end
