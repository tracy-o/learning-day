defmodule Belfrage.RequestTransformers.WeatherLanguageCookieTest do
  use ExUnit.Case, async: true
  import Fixtures.Struct
  alias Belfrage.RequestTransformers.WeatherLanguageCookie

  @redirect_languages ["en", "cy", "ga", "gd"]

  test "301 redirect when language in redirect_languages" do
    for lang <- @redirect_languages do
      struct = request_struct(:https, "www.bbc.co.uk", "/weather/language/#{lang}", %{}, %{"language" => lang})
      cookie = "ckps_language=#{lang}; expires=#{next_year_http_date()}; path=/; domain=.bbc.co.uk"

      assert {
               :redirect,
               %{
                 response: %{
                   http_status: 301,
                   body: "",
                   headers: %{
                     "location" => "https://www.bbc.co.uk/weather",
                     "set-cookie" => ^cookie,
                     "cache-control" => "public, stale-if-error=90, stale-while-revalidate=30, max-age=60"
                   }
                 }
               }
             } = WeatherLanguageCookie.call([], struct)
    end
  end

  test "does not 301 redirect when language is not in redirect_languages" do
    struct = request_struct(:https, "www.bbc.co.uk", "/weather/language/ab", %{}, %{"language" => "ab"})

    assert {:ok, struct} == WeatherLanguageCookie.call([], struct)
  end

  defp next_year_http_date() do
    {:ok, current} = DateTime.now("Etc/UTC")

    %{current | year: current.year + 1}
    |> Calendar.strftime("%a, %d %b %Y %H:%M:%S GMT")
  end
end
