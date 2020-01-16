defmodule BelfrageWeb.RouteMasterTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox

  alias Belfrage.Struct
  alias Routes.RoutefileMock

  describe "calling handle when using the only_on option" do
    @struct_with_html_response %Struct{
      response: %Struct.Response{
        body: "<p>Basic HTML response</p>",
        headers: %{"content-type" => "text/html; charset=utf-8"},
        http_status: 200
      }
    }

    test "when the environments dont match, it will return a 404" do
      BelfrageMock
      |> expect(:handle, 0, fn _struct ->
        raise "this should never run"
      end)

      conn =
        conn(:get, "/only-on")
        |> put_private(:bbc_headers, %{
          country: "gb",
          scheme: "",
          host: "",
          replayed_traffic: "",
          varnish: "",
          cache: ""
        })
        |> put_private(:production_environment, "some_other_environment")
        |> RoutefileMock.call([])

      assert conn.status == 404
      assert conn.resp_body == "404 Not Found"
    end

    test "when the environments match, it will continue with the request" do
      BelfrageMock
      |> expect(:handle, fn %Struct{
                              private: %Struct.Private{loop_id: "SomeLoop"},
                              request: %Struct.Request{path: "/only-on"}
                            } ->
        @struct_with_html_response
      end)

      conn =
        conn(:get, "/only-on")
        |> put_private(:bbc_headers, %{
          country: "gb",
          scheme: "",
          host: "",
          replayed_traffic: "",
          varnish: "",
          cache: ""
        })
        |> put_private(:production_environment, "some_environment")
        |> RoutefileMock.call([])

      assert conn.status == 200
    end
  end
end
