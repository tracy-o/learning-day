defmodule EndToEnd.BitesizeTopicsPlatformSelectorTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  alias Belfrage.RouteState
  use Test.Support.Helper, :mox
  alias Belfrage.Clients.{LambdaMock, HTTPMock, HTTP.Response}

  import Test.Support.Helper, only: [set_environment: 1]

  @successful_lambda_response {:ok, %{"statusCode" => 200, "headers" => %{}, "body" => "OK"}}
  @successful_http_response {:ok,
                             %Response{status_code: 200, headers: %{"content-type" => "application/json"}, body: "OK"}}

  setup do
    :ets.delete_all_objects(:cache)
    :ok
  end

  describe "requests with id and year_id path parameter keys" do
    test "if the id is a test webcore id, the year_id is valid and the production environment is test Webcore is returned" do
      start_supervised!({RouteState, "BitesizeTopics.Webcore"})

      expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
        @successful_lambda_response
      end)

      :get
      |> conn("/bitesize/topics/z82hsbk/year/zncsscw")
      |> Router.call(routefile: Routes.Routefiles.Main.Live)
    end

    test "if the id is a live webcore id, the year_id is valid and the production environment is live Webcore is returned" do
      set_environment("live")

      start_supervised!({RouteState, "BitesizeTopics.Webcore"})

      expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
        @successful_lambda_response
      end)

      :get
      |> conn("/bitesize/topics/zhtcvk7/year/zncsscw")
      |> Router.call(routefile: Routes.Routefiles.Main.Live)
    end

    test "if the id is a not a test webcore id, the year_id is valid and the production environment is test MorphRouter is returned" do
      start_supervised!({RouteState, "BitesizeTopics.MorphRouter"})

      expect(HTTPMock, :execute, fn _request, :MorphRouter ->
        @successful_http_response
      end)

      :get
      |> conn("/bitesize/topics/some_id/year/zncsscw")
      |> Router.call(routefile: Routes.Routefiles.Main.Live)
    end

    test "if the id is a test webcore id, the year_id is not valid and the production environment is test MorphRouter is returned" do
      start_supervised!({RouteState, "BitesizeTopics.MorphRouter"})

      expect(HTTPMock, :execute, fn _request, :MorphRouter ->
        @successful_http_response
      end)

      :get
      |> conn("/bitesize/topics/z82hsbk/year/some_year_id")
      |> Router.call(routefile: Routes.Routefiles.Main.Live)
    end

    test "if the id is a test webcore id, the year_id is valid and the production environment is live MorphRouter is returned" do
      set_environment("live")

      start_supervised!({RouteState, "BitesizeTopics.MorphRouter"})

      expect(HTTPMock, :execute, fn _request, :MorphRouter ->
        @successful_http_response
      end)

      :get
      |> conn("/bitesize/topics/z82hsbk/year/zncsscw")
      |> Router.call(routefile: Routes.Routefiles.Main.Live)
    end

    test "if the id is not a live webcore id, the year_id is valid and the production environment is live MorphRouter is returned" do
      set_environment("live")

      start_supervised!({RouteState, "BitesizeTopics.MorphRouter"})

      expect(HTTPMock, :execute, fn _request, :MorphRouter ->
        @successful_http_response
      end)

      :get
      |> conn("/bitesize/topics/some_id/year/zncsscw")
      |> Router.call(routefile: Routes.Routefiles.Main.Live)
    end

    test "if the id is a live webcore id, the year_id is invalid and the production environment is live MorphRouter is returned" do
      set_environment("live")

      start_supervised!({RouteState, "BitesizeTopics.MorphRouter"})

      expect(HTTPMock, :execute, fn _request, :MorphRouter ->
        @successful_http_response
      end)

      :get
      |> conn("/bitesize/topics/zhtcvk7/year/some_year_id")
      |> Router.call(routefile: Routes.Routefiles.Main.Live)
    end

    test "if the id is a live webcore id, the year_id is valid and the production environment is test Webcore is returned as all the live ids are a subset of the test ids" do
      set_environment("test")

      start_supervised!({RouteState, "BitesizeTopics.Webcore"})

      expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
        @successful_lambda_response
      end)

      :get
      |> conn("/bitesize/topics/zhtcvk7/year/zncsscw")
      |> Router.call(routefile: Routes.Routefiles.Main.Live)
    end
  end

  describe "requests with an id paramater key" do
    test "if the id is a test webcore id and the production environment is test Webcore is returned" do
      start_supervised!({RouteState, "BitesizeTopics.Webcore"})

      expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
        @successful_lambda_response
      end)

      :get
      |> conn("/bitesize/topics/z82hsbk")
      |> Router.call(routefile: Routes.Routefiles.Main.Live)
    end

    test "if the id is a live webcore id and the production environment is live Webcore is returned" do
      set_environment("live")

      start_supervised!({RouteState, "BitesizeTopics.Webcore"})

      expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
        @successful_lambda_response
      end)

      :get
      |> conn("/bitesize/topics/zhtcvk7")
      |> Router.call(routefile: Routes.Routefiles.Main.Live)
    end

    test "if the id is a not a test webcore id and the production environment is test MorphRouter is returned" do
      start_supervised!({RouteState, "BitesizeTopics.MorphRouter"})

      expect(HTTPMock, :execute, fn _request, :MorphRouter ->
        @successful_http_response
      end)

      :get
      |> conn("/bitesize/topics/some_id")
      |> Router.call(routefile: Routes.Routefiles.Main.Live)
    end

    test "if the id is a test webcore id and the production environment is live MorphRouter is returned" do
      set_environment("live")

      start_supervised!({RouteState, "BitesizeTopics.MorphRouter"})

      expect(HTTPMock, :execute, fn _request, :MorphRouter ->
        @successful_http_response
      end)

      :get
      |> conn("/bitesize/topics/z82hsbk")
      |> Router.call(routefile: Routes.Routefiles.Main.Live)
    end

    test "if the id is not a live webcore id and the production environment is live MorphRouter is returned" do
      set_environment("live")

      start_supervised!({RouteState, "BitesizeTopics.MorphRouter"})

      expect(HTTPMock, :execute, fn _request, :MorphRouter ->
        @successful_http_response
      end)

      :get
      |> conn("/bitesize/topics/some_id")
      |> Router.call(routefile: Routes.Routefiles.Main.Live)
    end

    test "if the id is a live webcore id and the production environment is test Webcore is returned as all the live ids are a subset of the test ids" do
      set_environment("test")

      start_supervised!({RouteState, "BitesizeTopics.Webcore"})

      expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
        @successful_lambda_response
      end)

      :get
      |> conn("/bitesize/topics/zhtcvk7")
      |> Router.call(routefile: Routes.Routefiles.Main.Live)
    end
  end
end
