defmodule Belfrage.Transformers.SportTemporaryRedirect do
  use Belfrage.Transformers.Transformer

  def call(rest, struct) do
    location = redirect_to(struct.request.path)

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

      String.match?(path, ~r/\/sport\/commonwealth-games\/(home-nations|medals|results|schedule|sports).app$/) ->
        "/sport/commonwealth-games.app"

      String.match?(path, ~r/\/sport\/commonwealth-games\/(home-nations|medals|results|schedule|sports)$/) ->
        "/sport/commonwealth-games"

      String.match?(path, ~r/\/sport\/formula1\/standings.app$/) ->
        "/sport/formula1/drivers-world-championship/standings.app"

      String.match?(path, ~r/\/sport\/formula1\/standings$/) ->
        "/sport/formula1/drivers-world-championship/standings"

      String.match?(path, ~r/\/sport\/football\/european-championship\/schedule(\/.*)?.app$/) ->
        "/sport/football/european-championship.app"

      String.match?(path, ~r/\/sport\/football\/european-championship\/schedule(\/.*)?$/) ->
        "/sport/football/european-championship"

      String.match?(path, ~r/\/sport\/football\/world-cup\/schedule(\/.*)?.app$/) ->
        "/sport/football/world-cup.app"

      String.match?(path, ~r/\/sport\/football\/world-cup\/schedule(\/.*)?$/) ->
        "/sport/football/world-cup"

      String.match?(path, ~r/\/sport\/winter-olympics\/(medals|results|schedule)\/.*.app$/) ->
        "/sport/winter-olympics.app"

      String.match?(path, ~r/\/sport\/winter-olympics\/(medals|results|schedule)\/.*/) ->
        "/sport/winter-olympics"

      String.match?(path, ~r/\/sport\/winter-olympics\/(home-nations|medals|results|schedule|sports).app$/) ->
        "/sport/winter-olympics.app"

      String.match?(path, ~r/\/sport\/winter-olympics\/(home-nations|medals|results|schedule|sports)$/) ->
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
