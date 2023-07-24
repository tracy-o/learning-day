defmodule EndToEnd.NewsLivePlatformSelectorTest do
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

  describe "NEWS uses correct platform" do
    test "if the id is a test webcore id and the production environment is test Webcore is returned" do
      expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
        @successful_lambda_response
      end)

      :get
      |> conn("/news/live/c1v596ken6vt")
      |> Router.call(routefile: Routes.Routefiles.Main.Live)
    end

    test "NEWS - when CPS URL with asset ID and page number provided, show MozartNews" do
      expect(HTTPMock, :execute, fn _request, :MozartNews ->
        @successful_http_response
      end)

      :get
      |> conn("/news/live/world-europe-61224804/page/3")
      |> Router.call(routefile: Routes.Routefiles.Main.Live)
    end

    test "NEWS - when CPS URL with asset ID and provided query params, show MozartNews" do
      expect(HTTPMock, :execute, fn _request, :MozartNews ->
        @successful_http_response
      end)

      :get
      |> conn("/news/live/world-europe-61224804?pinned_post_locator=urn:asset:786c4090-96b1-49c3-b5ca-80de970ec7de")
      |> Router.call(routefile: Routes.Routefiles.Main.Live)
    end

    test "NEWS - when CPS URL with asset ID provided, show MozartNews on test" do
      expect(HTTPMock, :execute, fn _request, :MozartNews ->
        @successful_http_response
      end)

      :get
      |> conn("/news/live/uk-66116088")
      |> Router.call(routefile: Routes.Routefiles.Main.Live)
    end

    test "NEWS - when with TIPO .app URL with page and post, show WebCore" do
      set_environment("live")

      expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
        @successful_lambda_response
      end)

      :get
      |> conn("/news/live/c1v596ken6vt?page=10&post=asset:9b3e3cb9-3997-43e8-b489-1d147be314ed")
      |> Router.call(routefile: Routes.Routefiles.Main.Live)
    end

    test "NEWS - when with TIPO .app URL, show WebCore" do
      set_environment("live")

      expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
        @successful_lambda_response
      end)

      :get
      |> conn("/news/live/cmqnxg444ket.app")
      |> Router.call(routefile: Routes.Routefiles.Main.Live)
    end
  end
end
