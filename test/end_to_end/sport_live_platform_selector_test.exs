defmodule EndToEnd.SportLivePlatformSelectorTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
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

  describe "SPORT uses correct platform" do
    test "if the id is a test webcore id and the production environment is test Webcore is returned" do
      expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
        @successful_lambda_response
      end)

      :get
      |> conn("/sport/live/cvpx5wr4nv8t")
      |> Router.call(routefile: Routes.Routefiles.Sport.Live)
    end

    test "SPORT - when CPS URL with asset ID and page number provided, show MozartSport" do
      expect(HTTPMock, :execute, fn _request, :MozartSport ->
        @successful_http_response
      end)

      :get
      |> conn("/sport/live/23583271/page/3")
      |> Router.call(routefile: Routes.Routefiles.Sport.Live)
    end

    test "SPORT - when CPS URL with asset ID and page number provided and .app route, show MozartSport" do
      expect(HTTPMock, :execute, fn _request, :MozartSport ->
        @successful_http_response
      end)

      :get
      |> conn("/sport/live/23583271/page/3.app")
      |> Router.call(routefile: Routes.Routefiles.Sport.Live)
    end

    test "SPORT - when CPS URL with asset ID provided, show MozartSport on test" do
      expect(HTTPMock, :execute, fn _request, :MozartSport ->
        @successful_http_response
      end)

      :get
      |> conn("/sport/live/cricket/64958413")
      |> Router.call(routefile: Routes.Routefiles.Sport.Live)
    end

    test "SPORT - when with TIPO .app URL with page and post, show WebCore" do
      set_environment("live")

      expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
        @successful_lambda_response
      end)

      :get
      |> conn("/sport/live/cmqnxg444ket.app?page=10&post=asset:cf7402da-c94c-4400-8662-c7ebd65ba957")
      |> Router.call(routefile: Routes.Routefiles.Sport.Live)
    end

    test "SPORT - when with TIPO .app URL, show WebCore" do
      set_environment("live")

      expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
        @successful_lambda_response
      end)

      :get
      |> conn("/sport/live/cmqnxg444ket.app")
      |> Router.call(routefile: Routes.Routefiles.Sport.Live)
    end
  end
end
