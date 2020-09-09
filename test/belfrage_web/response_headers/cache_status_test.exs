defmodule BelfrageWeb.ResponseHeaders.CacheStatusTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.ResponseHeaders.CacheStatus
  alias Belfrage.Struct

  describe "when response origin is from belfrage cache" do
    test "the belfrage-cache-status header has the value 'HIT'" do
      struct = %Struct{private: %Struct.Private{origin: :belfrage_cache}}

      conn =
        conn(:get, "/")
        |> CacheStatus.add_header(struct)

      assert ["HIT"] == get_resp_header(conn, "belfrage-cache-status")
    end
  end

  describe "when the response origin not from belfrage cache" do
    test "the belfrage-cache-status header has the value 'MISS'" do
      struct = %Struct{}

      conn =
        conn(:get, "/")
        |> CacheStatus.add_header(struct)

      assert ["MISS"] == get_resp_header(conn, "belfrage-cache-status")
    end
  end
end