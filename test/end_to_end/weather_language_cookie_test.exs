defmodule EndToEnd.WeatherLanguageCookieTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  alias BelfrageWeb.Router
  alias Belfrage.{RouteState, Clients.HTTP, Clients.HTTPMock}
  import Belfrage.Test.CachingHelper, only: [clear_cache: 0]

  @redirect_languages ["en", "cy", "ga", "gd"]

  setup do
    start_supervised!({RouteState, "SomeRouteState"})
    clear_cache()
    :ok
  end

  test "weather/language/:language redirects when language segment is in redirect_languages" do
    for lang <- @redirect_languages do
      response_conn =
        conn(:get, "/weather/language/#{lang}")
        |> Router.call(routefile: Routes.Routefiles.Main.Test)

      assert {301, _headers, "Redirecting"} = sent_resp(response_conn)
    end
  end

  test "weather/language/:language does not redirect when language is not in redirect_langugages" do
    expect(HTTPMock, :execute, fn _request, _pool ->
      {:ok,
       %HTTP.Response{
         headers: %{
           "cache-control" => "public, max-age=30"
         },
         status_code: 200,
         body: "Hello from MozartWeather"
       }}
    end)

    response_conn =
      conn(:get, "/weather/language/ab")
      |> Router.call(routefile: Routes.Routefiles.Main.Test)

    assert {200, _headers, "Hello from MozartWeather"} = sent_resp(response_conn)
  end
end
