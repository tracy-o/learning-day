defmodule BelfrageWeb.LegacyTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox

  alias Belfrage.Struct
  alias Belfrage.Struct.{Private, Request}
  alias BelfrageWeb.Router

  describe "Routefile routes" do
    @struct_with_html_response %Struct{
      response: %Struct.Response{
        body: "<p>Basic HTML response</p>",
        headers: %{"content-type" => "text/html; charset=utf-8"},
        http_status: 200
      }
    }

    @struct_with_404_response %Struct{
      response: %Struct.Response{
        body: "Downstream not found",
        headers: %{"content-type" => "text/html; charset=utf-8"},
        http_status: 404
      }
    }

    test "200 GET" do
      BelfrageMock
      |> expect(:handle, fn %Struct{
                              private: %Private{loop_id: "SomeLoop"},
                              request: %Request{path: "/200-ok-response"}
                            } ->
        @struct_with_html_response
      end)

      conn = conn(:get, "/200-ok-response") |> Router.call([])

      assert conn.status == 200
      assert conn.resp_body == "<p>Basic HTML response</p>"
    end

    test "404 downstream GET" do
      BelfrageMock
      |> expect(:handle, fn %Struct{
                              private: %Private{loop_id: "SomeLoop"},
                              request: %Request{path: "/downstream-not-found"}
                            } ->
        @struct_with_404_response
      end)

      conn = conn(:get, "/downstream-not-found") |> Router.call([])

      assert conn.status == 404
      assert conn.resp_body == "Downstream not found"
    end

    test "404 invalid GET" do
      conn = conn(:get, "/premature-404") |> Router.call([])

      assert conn.status == 404
      assert conn.resp_body =~ "404"
    end

    test "301 redirect" do
      conn = conn(:get, "/permanent-redirect") |> Router.call([])

      assert conn.status == 301
      assert get_resp_header(conn, "location") == ["/new-location"]
    end

    test "302 redirect" do
      conn = conn(:get, "/temp-redirect") |> Router.call([])

      assert conn.status == 302
      assert get_resp_header(conn, "location") == ["/temp-location"]
    end
  end
end
