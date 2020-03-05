defmodule Routes.RoutefileTest do
  use ExUnit.Case
  use Plug.Test

  use Test.Support.Helper, :mox

  alias BelfrageWeb.Router
  alias Belfrage.Struct

  @moduletag :routes_test

  Enum.each(Routes.Routefile.routes(), fn {route_matcher, loop_id, examples} ->
    describe "For route matcher: #{route_matcher}" do
      @loop_id loop_id
      @examples examples

      Enum.each(@examples, fn example ->
        @example example

        test "The example: #{example} points to the #{loop_id} routespec" do
          BelfrageMock
          |> expect(
            :handle,
            fn struct = %Struct{
                 private: %Struct.Private{
                   loop_id: @loop_id
                 }
               } ->
              Struct.add(
                struct,
                :response,
                %Struct.Response{http_status: 200, body: "The example uses the correct loop"}
              )
            end
          )

          conn = conn(:get, @example)
          conn = Router.call(conn, [])

          assert conn.status == 200
          assert conn.resp_body == "The example uses the correct loop"
        end
      end)
    end
  end)
end
