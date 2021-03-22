defmodule Belfrage.Transformers.SportRedirectTest do
  use ExUnit.Case, async: true
  import Fixtures.Struct

  alias Belfrage.Transformers.SportRedirect

  test "unmatched request will not redirect" do
    struct = request_struct(:https, "sub.domain.bbc.com", "/sport/url/that/does/not/match")

    assert {:ok, struct} = SportRedirect.call([], struct)
  end

  test_301_cases = %{
    "/sport/football/european-championship/2012" => "/sport/football/european-championship",
    "/sport/football/european-championship/2012.app" => "/sport/football/european-championship.app",
    "/sport/football/european-championship/2016" => "/sport/football/european-championship",
    "/sport/football/european-championship/2016.app" => "/sport/football/european-championship.app",
    "/sport/football/european-championship/euro-2016" => "/sport/football/european-championship",
    "/sport/football/european-championship/euro-2016.app" => "/sport/football/european-championship.app",
    "/sport/football/european-championship/euro-2016/something" => "/sport/football/european-championship",
    "/sport/football/european-championship/euro-2016/something.app" => "/sport/football/european-championship.app",
    "/sport/olympics/2012" => "/sport/olympics",
    "/sport/olympics/2012.app" => "/sport/olympics.app",
    "/sport/olympics/2012/something" => "/sport/olympics",
    "/sport/olympics/2012/something.app" => "/sport/olympics.app",
    "/sport/olympics/2016" => "/sport/olympics",
    "/sport/olympics/2016.app" => "/sport/olympics.app",
    "/sport/olympics/2016/something" => "/sport/olympics",
    "/sport/olympics/2016/something.app" => "/sport/olympics.app",
    "/sport/olympics/rio-2016" => "/sport/olympics",
    "/sport/olympics/rio-2016.app" => "/sport/olympics.app",
    "/sport/olympics/rio-2016/something" => "/sport/olympics",
    "/sport/olympics/rio-2016/something.app" => "/sport/olympics.app",
    "/sport/paralympics/rio-2016/medals" => "/sport/disability-sport",
    "/sport/paralympics/rio-2016/medals.app" => "/sport/disability-sport.app",
    "/sport/paralympics/rio-2016/medals/something" => "/sport/disability-sport",
    "/sport/paralympics/rio-2016/medals/something.app" => "/sport/disability-sport.app",
    "/sport/paralympics/rio-2016/schedule" => "/sport/disability-sport",
    "/sport/paralympics/rio-2016/schedule.app" => "/sport/disability-sport.app",
    "/sport/paralympics/rio-2016/schedule/something" => "/sport/disability-sport",
    "/sport/paralympics/rio-2016/schedule/something.app" => "/sport/disability-sport.app"
  }

  Enum.each(test_301_cases, fn {input, expected_redirect} ->
    test "#{input} should 301 redirect to #{expected_redirect}" do
      struct = request_struct(:https, "sub.domain.bbc.com", unquote(input))

      assert {
               :redirect,
               %{
                 response: %{
                   http_status: 301,
                   body: "Redirecting",
                   headers: %{
                     "location" => unquote(expected_redirect),
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "public, stale-while-revalidate=10, max-age=3600"
                   }
                 }
               }
             } = SportRedirect.call([], struct)
    end
  end)

  test_302_cases = %{
    "/sport/commonwealth-games/home-nations" => "/sport/commonwealth-games",
    "/sport/commonwealth-games/home-nations.app" => "/sport/commonwealth-games.app",
    "/sport/commonwealth-games/medals" => "/sport/commonwealth-games",
    "/sport/commonwealth-games/medals.app" => "/sport/commonwealth-games.app",
    "/sport/commonwealth-games/medals/something" => "/sport/commonwealth-games",
    "/sport/commonwealth-games/medals/something.app" => "/sport/commonwealth-games.app",
    "/sport/commonwealth-games/results" => "/sport/commonwealth-games",
    "/sport/commonwealth-games/results.app" => "/sport/commonwealth-games.app",
    "/sport/commonwealth-games/results/something" => "/sport/commonwealth-games",
    "/sport/commonwealth-games/results/something.app" => "/sport/commonwealth-games.app",
    "/sport/commonwealth-games/schedule" => "/sport/commonwealth-games",
    "/sport/commonwealth-games/schedule.app" => "/sport/commonwealth-games.app",
    "/sport/commonwealth-games/schedule/something" => "/sport/commonwealth-games",
    "/sport/commonwealth-games/schedule/something.app" => "/sport/commonwealth-games.app",
    "/sport/commonwealth-games/sports" => "/sport/commonwealth-games",
    "/sport/commonwealth-games/sports.app" => "/sport/commonwealth-games.app",
    "/sport/football/european-championship/schedule" => "/sport/football/european-championship",
    "/sport/football/european-championship/schedule.app" => "/sport/football/european-championship.app",
    "/sport/football/european-championship/schedule/something" => "/sport/football/european-championship",
    "/sport/football/european-championship/schedule/something.app" => "/sport/football/european-championship.app",
    "/sport/football/world-cup/schedule" => "/sport/football/world-cup",
    "/sport/football/world-cup/schedule.app" => "/sport/football/world-cup.app",
    "/sport/football/world-cup/schedule/something" => "/sport/football/world-cup",
    "/sport/football/world-cup/schedule/something.app" => "/sport/football/world-cup.app",
    "/sport/winter-olympics/home-nations" => "/sport/winter-olympics",
    "/sport/winter-olympics/home-nations.app" => "/sport/winter-olympics.app",
    "/sport/winter-olympics/medals" => "/sport/winter-olympics",
    "/sport/winter-olympics/medals.app" => "/sport/winter-olympics.app",
    "/sport/winter-olympics/medals/something" => "/sport/winter-olympics",
    "/sport/winter-olympics/medals/something.app" => "/sport/winter-olympics.app",
    "/sport/winter-olympics/results" => "/sport/winter-olympics",
    "/sport/winter-olympics/results.app" => "/sport/winter-olympics.app",
    "/sport/winter-olympics/results/something" => "/sport/winter-olympics",
    "/sport/winter-olympics/results/something.app" => "/sport/winter-olympics.app",
    "/sport/winter-olympics/schedule" => "/sport/winter-olympics",
    "/sport/winter-olympics/schedule.app" => "/sport/winter-olympics.app",
    "/sport/winter-olympics/schedule/something" => "/sport/winter-olympics",
    "/sport/winter-olympics/schedule/something.app" => "/sport/winter-olympics.app",
    "/sport/winter-olympics/sports" => "/sport/winter-olympics",
    "/sport/winter-olympics/sports.app" => "/sport/winter-olympics.app"
  }

  Enum.each(test_302_cases, fn {input, expected_redirect} ->
    test "#{input} should 302 redirect to #{expected_redirect}" do
      struct = request_struct(:https, "sub.domain.bbc.com", unquote(input))

      assert {
               :redirect,
               %{
                 response: %{
                   http_status: 302,
                   body: "Redirecting",
                   headers: %{
                     "location" => unquote(expected_redirect),
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "public, stale-while-revalidate=10, max-age=3600"
                   }
                 }
               }
             } = SportRedirect.call([], struct)
    end
  end)
end
