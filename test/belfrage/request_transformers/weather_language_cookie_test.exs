defmodule Belfrage.RequestTransformers.WeatherLanguageCookieTest do
  use ExUnit.Case, async: true
  import Fixtures.Struct
  alias Belfrage.RequestTransformers.WeatherLanguageCookie

  @cookie "ckps_language=en; expires=#{WeatherLanguageCookie.next_year_http_date()}; path=/; domain=www"

  test "301 redirect when /weather/language/:language" do
    struct = request_struct(:https, "www.bbc.co.uk", "/weather/language/en")

    assert {
             :redirect,
             %{
               response: %{
                 http_status: 301,
                 body: "Redirecting",
                 headers: %{
                   "location" => "https://www.bbc.co.uk/weather",
                   "set-cookie" => @cookie,
                   "cache-control" => "public, stale-if-error=90, stale-while-revalidate=30, max-age=60"
                 }
               }
             }
           } = WeatherLanguageCookie.call([], struct)
  end
end
