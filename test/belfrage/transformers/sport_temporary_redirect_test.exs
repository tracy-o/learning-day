defmodule Belfrage.Transformers.SportTemporaryRedirectTest do
  use ExUnit.Case, async: true
  import Fixtures.Struct

  alias Belfrage.Transformers.SportTemporaryRedirect

  test "unmatched request will not redirect" do
    struct = request_struct(:https, "sub.domain.bbc.com", "/sport/url/that/does/not/match")

    assert {:ok, struct} = SportTemporaryRedirect.call([], struct)
  end

  test_cases = %{
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
    "/sport/formula1/standings" => "/sport/formula1/drivers-world-championship/standings",
    "/sport/formula1/standings.app" => "/sport/formula1/drivers-world-championship/standings.app",
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
    "/sport/winter-olympics/sports.app" => "/sport/winter-olympics.app",
  }

  Enum.each test_cases, fn({input, expected_redirect}) ->
    test "#{input} should redirect to #{expected_redirect}" do
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
                    "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                  }
                }
              }
            } = SportTemporaryRedirect.call([], struct)
    end
  end
end
