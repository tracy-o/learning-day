defmodule EndToEnd.WeatherLanguageCookieTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  alias BelfrageWeb.Router
  import Belfrage.Test.CachingHelper, only: [clear_cache: 0]

  @redirect_languages ["en", "cy", "ga", "gd"]

  setup do
    clear_cache()
  end

  test "weather/language/:language redirects when language segment is in redirect_languages" do
    for lang <- @redirect_languages do
      response_conn =
        conn(:get, "/weather/language/#{lang}")
        |> Router.call(routefile: Routes.Routefiles.Main.Test)

      assert {301, _headers, ""} = sent_resp(response_conn)
    end
  end

  test "weather/language/:language returns a 404 when language is not in redirect_langugages" do
    response_conn =
      conn(:get, "/weather/language/ab")
      |> Router.call(routefile: Routes.Routefiles.Main.Test)

    assert {404, _headers, "<h1>404 Page Not Found</h1>\n<!-- Belfrage -->"} = sent_resp(response_conn)
  end

  test "weather/language/:language returns a 404 when redirect_location is not valid" do
    response_conn =
      conn(:get, "/weather/language/ab?redirect_location=not_valid")
      |> Router.call(routefile: Routes.Routefiles.Main.Test)

    assert {404, _headers, "<h1>404 Page Not Found</h1>\n<!-- Belfrage -->"} = sent_resp(response_conn)
  end
end
