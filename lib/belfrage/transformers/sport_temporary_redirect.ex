defmodule Belfrage.Transformers.SportTemporaryRedirect do
  use Belfrage.Transformers.Transformer

  @absolute_paths %{
    "/sport/commonwealth-games/home-nations" => "/sport/commonwealth-games",
    "/sport/commonwealth-games/home-nations.app" => "/sport/commonwealth-games.app",
    "/sport/commonwealth-games/medals" => "/sport/commonwealth-games",
    "/sport/commonwealth-games/medals.app" => "/sport/commonwealth-games.app",
    "/sport/commonwealth-games/results" => "/sport/commonwealth-games",
    "/sport/commonwealth-games/results.app" => "/sport/commonwealth-games.app",
    "/sport/commonwealth-games/schedule" => "/sport/commonwealth-games",
    "/sport/commonwealth-games/schedule.app" => "/sport/commonwealth-games.app",
    "/sport/commonwealth-games/sports" => "/sport/commonwealth-games",
    "/sport/commonwealth-games/sports.app" => "/sport/commonwealth-games.app",
    "/sport/football/european-championship/schedule" => "/sport/football/european-championship",
    "/sport/football/european-championship/schedule.app" => "/sport/football/european-championship.app",
    "/sport/football/world-cup/schedule" => "/sport/football/world-cup",
    "/sport/football/world-cup/schedule.app" => "/sport/football/world-cup.app",
    "/sport/formula1/standings" => "/sport/formula1/drivers-world-championship/standings",
    "/sport/formula1/standings.app" => "/sport/formula1/drivers-world-championship/standings.app",
    "/sport/winter-olympics/home-nations" => "/sport/winter-olympics",
    "/sport/winter-olympics/home-nations.app" => "/sport/winter-olympics.app",
    "/sport/winter-olympics/medals" => "/sport/winter-olympics",
    "/sport/winter-olympics/medals.app" => "/sport/winter-olympics.app",
    "/sport/winter-olympics/results" => "/sport/winter-olympics",
    "/sport/winter-olympics/results.app" => "/sport/winter-olympics.app",
    "/sport/winter-olympics/schedule" => "/sport/winter-olympics",
    "/sport/winter-olympics/schedule.app" => "/sport/winter-olympics.app",
    "/sport/winter-olympics/sports" => "/sport/winter-olympics",
    "/sport/winter-olympics/sports.app" => "/sport/winter-olympics.app"
  }
  
  def call(rest, struct) do
    location = @absolute_paths[struct.request.path] || redirect_to(struct.request.path)

    case location !== nil do
      true -> redirect(location, struct)
      _ -> then(rest, struct)
    end
  end

  def redirect_to(path) do
    cond do
      String.match?(path, ~r/\/sport\/commonwealth-games\/(medals|results|schedule)\/.*.app$/) ->
        "/sport/commonwealth-games.app"

      String.match?(path, ~r/\/sport\/commonwealth-games\/(medals|results|schedule)\/.*/) ->
        "/sport/commonwealth-games"

      String.match?(path, ~r/\/sport\/football\/european-championship\/schedule(\/.*)?.app$/) ->
        "/sport/football/european-championship.app"

      String.match?(path, ~r/\/sport\/football\/european-championship\/schedule\/.*?$/) ->
        "/sport/football/european-championship"

      String.match?(path, ~r/\/sport\/football\/world-cup\/schedule\/.*.app$/) ->
        "/sport/football/world-cup.app"

      String.match?(path, ~r/\/sport\/football\/world-cup\/schedule\/.*/) ->
        "/sport/football/world-cup"

      String.match?(path, ~r/\/sport\/winter-olympics\/(medals|results|schedule)\/.*.app$/) ->
        "/sport/winter-olympics.app"

      String.match?(path, ~r/\/sport\/winter-olympics\/(medals|results|schedule)\/.*/) ->
        "/sport/winter-olympics"

      true ->
        nil
    end
  end

  def redirect(location, struct) do
    {
      :redirect,
      Struct.add(struct, :response, %{
        http_status: 302,
        headers: %{
          "location" => location,
          "x-bbc-no-scheme-rewrite" => "1",
          "cache-control" => "public, stale-while-revalidate=10, max-age=60"
        },
        body: "Redirecting"
      })
    }
  end
end
