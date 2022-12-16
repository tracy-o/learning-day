defmodule Belfrage.RequestTransformers.WeatherLanguageCookieTest do
  use ExUnit.Case, async: true
  import Fixtures.Struct
  alias Belfrage.RequestTransformers.WeatherLanguageCookie
  alias Belfrage.Utils.Current

  test "returns 301 redirect when language one of the redirect_languages and redirect_location is not set" do
    Current.Mock.freeze(~D[2022-12-16], ~T[08:15:45.368815Z])

    struct = request_struct(:https, "www.bbc.co.uk", "/weather/language/en", %{}, %{"language" => "en"})

    assert {
             :redirect,
             %{
               response: %{
                 http_status: 301,
                 body: "",
                 headers: %{
                   "location" => "https://www.bbc.co.uk/weather",
                   "set-cookie" => "ckps_language=en; expires=Sat, 16 Dec 2023 08:15:45 GMT; path=/; domain=.bbc.co.uk",
                   "cache-control" => "public, stale-if-error=90, stale-while-revalidate=30, max-age=60"
                 }
               }
             }
           } = WeatherLanguageCookie.call([], struct)

    on_exit(&Current.Mock.unfreeze/0)
  end

  test "returns 301 redirect and encodes query string when language one of the redirect_languages and redirect_location is valid" do
    Current.Mock.freeze(~D[2022-12-16], ~T[10:30:45.368815Z])

    struct =
      request_struct(:https, "www.bbc.co.uk", "/weather/language/en", %{"redirect_location" => "/weather/w1a"}, %{
        "language" => "en"
      })

    assert {
             :redirect,
             %{
               response: %{
                 http_status: 301,
                 body: "",
                 headers: %{
                   "location" => "https://www.bbc.co.uk/weather?redirect_location=%2Fweather%2Fw1a",
                   "set-cookie" => "ckps_language=en; expires=Sat, 16 Dec 2023 10:30:45 GMT; path=/; domain=.bbc.co.uk",
                   "cache-control" => "public, stale-if-error=90, stale-while-revalidate=30, max-age=60"
                 }
               }
             }
           } = WeatherLanguageCookie.call([], struct)

    on_exit(&Current.Mock.unfreeze/0)
  end

  test "returns a 400 when language is not in redirect_languages" do
    struct = request_struct(:https, "www.bbc.co.uk", "/weather/language/ab", %{}, %{"language" => "ab"})

    assert {
             :stop_pipeline,
             %{
               response: %{
                 http_status: 400,
                 body: "",
                 headers: %{}
               }
             }
           } = WeatherLanguageCookie.call([], struct)
  end

  test "returns a 404 when redirect_location is not valid" do
    struct =
      request_struct(:https, "www.bbc.co.uk", "/weather/language/cy", %{"redirect_location" => "not_valid"}, %{
        "language" => "cy"
      })

    assert {
             :stop_pipeline,
             %{
               response: %{
                 http_status: 404,
                 body: "",
                 headers: %{}
               }
             }
           } = WeatherLanguageCookie.call([], struct)
  end
end
