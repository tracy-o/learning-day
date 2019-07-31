defmodule BelfrageWeb.RequestHeaders.HandlerTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.RequestHeaders.Handler

  describe "call" do
    test "sets edge country header in the conn" do
      conn = conn("get", "/", "") |> put_req_header("x-bbc-edge-country", "gb")

      assert %{
               bbc_headers: %{cache: false, country: "gb", host: ""}
             } = Handler.call(conn, []).private
    end

    test "sets replayed traffic header in the conn" do
      conn = conn("get", "/", "") |> put_req_header("replayed-traffic", "true")

      assert %{
               bbc_headers: %{replayed_traffic: true}
             } = Handler.call(conn, []).private
    end

    test "ignores replayed-traffic value if not 'true'" do
      conn = conn("get", "/", "") |> put_req_header("replayed-traffic", "invalid")

      assert %{
               bbc_headers: %{replayed_traffic: nil}
             } = Handler.call(conn, []).private
    end
  end
end
