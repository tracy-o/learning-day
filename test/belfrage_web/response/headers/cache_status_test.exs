defmodule BelfrageWeb.Response.Headers.CacheStatusTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.Response.Headers.CacheStatus
  alias Belfrage.Envelope

  describe "when response origin is from belfrage cache" do
    test "the belfrage-cache-status header has the value 'HIT'" do
      envelope = %Envelope{private: %Envelope.Private{origin: :belfrage_cache}}

      conn =
        conn(:get, "/")
        |> CacheStatus.add_header(envelope)

      assert ["HIT"] == get_resp_header(conn, "belfrage-cache-status")
    end
  end

  describe "when the response origin not from belfrage cache" do
    test "the belfrage-cache-status header has the value 'MISS'" do
      envelope = %Envelope{}

      conn =
        conn(:get, "/")
        |> CacheStatus.add_header(envelope)

      assert ["MISS"] == get_resp_header(conn, "belfrage-cache-status")
    end
  end

  describe "when the response is stale" do
    test "the belfrage-cache-status header has the value 'STALE'" do
      envelope = %Envelope{response: %Envelope.Response{fallback: true}}

      conn =
        conn(:get, "/")
        |> CacheStatus.add_header(envelope)

      assert ["STALE"] == get_resp_header(conn, "belfrage-cache-status")
    end

    test "the warning header has the value '111'" do
      envelope = %Envelope{response: %Envelope.Response{fallback: true}}

      conn =
        conn(:get, "/")
        |> CacheStatus.add_header(envelope)

      assert ["111"] == get_resp_header(conn, "warning")
    end
  end
end
