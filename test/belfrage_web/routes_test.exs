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
                              private: %Private{loop_id: "SportVideos"},
                              request: %Request{path: "/sport/videos/12345678"}
                            } ->
        @struct_with_html_response
      end)

      conn = conn(:get, "/sport/videos/12345678") |> Router.call([])

      assert conn.status == 200
      assert conn.resp_body == "<p>Basic HTML response</p>"
    end

    test "404 downstream GET" do
      BelfrageMock
      |> expect(:handle, fn %Struct{
                              private: %Private{loop_id: "SportVideos"},
                              request: %Request{path: "/sport/videos/12345678"}
                            } ->
        @struct_with_404_response
      end)

      conn = conn(:get, "/sport/videos/12345678") |> Router.call([])

      assert conn.status == 404
      assert conn.resp_body == "Downstream not found"
    end

    test "404 invalid GET" do
      conn = conn(:get, "/sport/videos/123456789123456789") |> Router.call([])

      assert conn.status == 404
      assert conn.resp_body == "404 Not Found"
    end

    test "301 redirect" do
      conn = conn(:get, "/example/weather/0") |> Router.call([])

      assert conn.status == 301
      assert get_resp_header(conn, "location") == ["/weather"]
    end

    test "302 redirect" do
      conn = conn(:get, "/example/news/0") |> Router.call([])

      assert conn.status == 302
      assert get_resp_header(conn, "location") == ["/news"]
    end
  end
end
