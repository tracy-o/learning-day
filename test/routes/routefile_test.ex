defmodule Routes.RoutefileTest do
  use ExUnit.Case
  use Plug.Test

  use Test.Support.Helper, :mox

  alias BelfrageWeb.Router
  alias Belfrage.Struct

  @redirect_statuses Application.get_env(:belfrage, :redirect_statuses)

  @moduletag :routes_test

  Enum.each(Routes.Routefile.routes(), fn {route_matcher, %{using: loop_id, examples: examples}} ->
    describe "For route matcher: #{route_matcher} (#{loop_id})" do
      @loop_id loop_id
      @route_matcher route_matcher

      for env <- ["test", "live"] do
        @env env
        test "There is a valid routespec for #{@loop_id} (#{@env})" do
          specs = Belfrage.RouteSpec.specs_for(@loop_id, @env)

          assert Map.has_key?(specs, :platform)
          assert Map.has_key?(specs, :pipeline)
          assert Map.has_key?(specs, :resp_pipeline)
          assert Map.has_key?(specs, :circuit_breaker_error_threshold)
          assert Map.has_key?(specs, :origin)

          for transformer <- specs.pipeline do
            assert Code.ensure_compiled?(Module.concat([Belfrage, Transformers, transformer])),
                   "`#{transformer}` is not a valid request transformer."
          end

          if @env == "live" do
            assert "DevelopmentRequests" not in specs.pipeline,
                   "Sorry, the `DevelopmentRequests` transformer cannot be used on live."
          end
        end
      end

      test "Route matcher #{@route_matcher} is prefixed with a `/`" do
        assert String.starts_with?(@route_matcher, "/"), "Route matcher #{@route_matcher} must be prefixed with a `/`."
      end

      examples
      |> Enum.map(fn
        {path, expected_status_code} -> {path, expected_status_code}
        path -> {path, 200}
      end)
      |> Enum.each(fn route_example ->
        {path, status_code} = route_example
        @path path
        @status_code status_code

        test "Route example #{@path} is prefixed with `/`" do
          assert String.starts_with?(@path, "/"),
                 "Route example `#{@path}`, for matcher `#{@route_matcher}`, must be prefixed with a `/`."
        end

        test "The example: #{@path} points to the #{loop_id} routespec" do
          unless @route_matcher == "/*any" or @status_code == 404 do
            BelfrageMock
            |> expect(
              :handle,
              fn struct = %Struct{
                   private: %Struct.Private{
                     loop_id: loop_id
                   }
                 } ->
                assert @loop_id == loop_id || @loop_id in loop_id

                Struct.add(
                  struct,
                  :response,
                  %Struct.Response{http_status: @status_code, body: "The example uses the correct loop"}
                )
              end
            )
          end

          conn = conn(:get, @path)
          conn = Router.call(conn, [])

          if @route_matcher == "/*any" or @status_code == 404 do
            assert conn.status == 404
            assert conn.resp_body == "content for file test/support/resources/not-found.html<!-- Belfrage -->"
          else
            assert conn.status == @status_code
            assert conn.resp_body == "The example uses the correct loop"
          end
        end
      end)
    end
  end)

  Enum.each(Routes.Routefile.redirects(), fn {from, to, status} ->
    @to to
    @status status

    describe "Redirect #{from} to #{to}" do
      test "location does not end with a *" do
        refute String.ends_with?(@to, "*")
      end

      test "status is a redirect" do
        assert @status in @redirect_statuses
      end
    end
  end)

  describe "for routes that arent supported" do
    defp expect_belfrage_not_called() do
      BelfrageMock
      |> expect(:handle, 0, fn _struct ->
        raise "this should never run"
      end)
    end

    test "when the request is a GET request" do
      Application.put_env(:belfrage, :production_environment, "live")

      conn = conn(:get, "/a_route_that_will_not_match")
      conn = Router.call(conn, [])

      assert conn.status == 404
      assert conn.resp_body == "content for file test/support/resources/not-found.html<!-- Belfrage -->"

      Application.put_env(:belfrage, :production_environment, "test")
    end

    test "when the request is a POST request" do
      expect_belfrage_not_called()

      conn = conn(:post, "/a_route_that_will_not_match")
      conn = Router.call(conn, [])

      assert conn.status == 405
      assert conn.resp_body == "content for file test/support/resources/not-supported.html<!-- Belfrage -->"
    end
  end
end
