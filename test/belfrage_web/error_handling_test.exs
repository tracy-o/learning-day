defmodule BelfrageWeb.ErrorHandlingTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox

  alias Belfrage.Struct
  alias Belfrage.Struct.Request
  alias BelfrageWeb.Router
  alias Test.Support.StructHelper

  @struct_with_404_response StructHelper.build(
                              response: %{
                                body: "404 Not Found",
                                headers: %{"content-type" => "text/html; charset=utf-8"},
                                http_status: 404
                              }
                            )

  describe "catchall for live routes" do
    setup do
      Application.put_env(:belfrage, :production_environment, "live")

      on_exit(fn ->
        Application.put_env(:belfrage, :production_environment, "test")
      end)
    end

    test "when on live responds with 404 status code for catch all" do
      BelfrageMock
      |> expect(:handle, fn %Struct{
                              request: %Request{path: "/foo_bar"}
                            } ->
        @struct_with_404_response
      end)

      conn = conn(:get, "/foo_bar")
      Router.call(conn, [])

      assert {404, _headers, "404 Not Found"} = sent_resp(conn)
    end
  end

  describe "catch all for test routes" do
    test "Responds with 500 status code" do
      BelfrageMock
      |> expect(:handle, fn _ ->
        raise("Something broke")
      end)

      conn = conn(:get, "/sport")

      assert_raise Plug.Conn.WrapperError, "** (RuntimeError) Something broke", fn ->
        Router.call(conn, [])
      end

      assert_received {:plug_conn, :sent}
      assert {500, _headers, "500 Internal Server Error"} = sent_resp(conn)
    end
  end
end
