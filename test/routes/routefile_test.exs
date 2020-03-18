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

      test "There is a valid routespec for #{loop_id}" do
        specs = Module.concat([Routes, Specs, @loop_id]).specs()

        assert Map.has_key?(specs, :platform)

        specs = Map.merge(Module.concat([Routes, Platforms, specs.platform]).specs(), specs)
        assert Map.has_key?(specs, :pipeline)
        assert Map.has_key?(specs, :resp_pipeline)
        assert Map.has_key?(specs, :circuit_breaker_error_threshold)
        assert Map.has_key?(specs, :origin)
      end

      Enum.each(examples, fn example ->
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
