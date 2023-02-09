defmodule BelfrageWeb.Response.Headers.CacheStatus do
  import Plug.Conn
  alias Belfrage.Envelope

  @behaviour BelfrageWeb.Response.Headers.Behaviour

  @impl true
  def add_header(conn, %Envelope{response: %Envelope.Response{fallback: true}}) do
    put_resp_header(conn, "belfrage-cache-status", "STALE")
    |> put_resp_header("warning", "111")
  end

  @impl true
  def add_header(conn, %Envelope{private: %Envelope.Private{origin: :belfrage_cache}}) do
    put_resp_header(conn, "belfrage-cache-status", "HIT")
  end

  def add_header(conn, _envelope) do
    put_resp_header(conn, "belfrage-cache-status", "MISS")
  end
end
