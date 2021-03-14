defmodule Belfrage.Transformers.SportRedirect do
  use Belfrage.Transformers.Transformer

  @absolute_paths %{
    "/sport/commonwealth-games/home-nations" => %{location: "/sport/commonwealth-games", status: 302},
    "/sport/commonwealth-games/home-nations.app" => %{location: "/sport/commonwealth-games.app", status: 302},
    "/sport/commonwealth-games/medals" => %{location: "/sport/commonwealth-games", status: 302},
    "/sport/commonwealth-games/medals.app" => %{location: "/sport/commonwealth-games.app", status: 302},
    "/sport/commonwealth-games/results" => %{location: "/sport/commonwealth-games", status: 302},
    "/sport/commonwealth-games/results.app" => %{location: "/sport/commonwealth-games.app", status: 302},
    "/sport/commonwealth-games/schedule" => %{location: "/sport/commonwealth-games", status: 302},
    "/sport/commonwealth-games/schedule.app" => %{location: "/sport/commonwealth-games.app", status: 302},
    "/sport/commonwealth-games/sports" => %{location: "/sport/commonwealth-games", status: 302},
    "/sport/commonwealth-games/sports.app" => %{location: "/sport/commonwealth-games.app", status: 302},
    "/sport/53783520" => %{location: "/sport/all-sports", status: 301},
    "/sport/53783520.app" => %{location: "/sport/all-sports.app", status: 301},
    "/sport/34476378" => %{location: "/sport/my-sport", status: 301},
    "/sport/34476378.app" => %{location: "/sport/my-sport.app", status: 301},
    "/sport/av/supermovers/12345678" => %{location: "/teach/supermovers", status: 301},
    "/sport/av/supermovers/12345678.app" => %{location: "/teach/supermovers", status: 301},
    "/sport/contact" => %{location: "/send/u49719405", status: 301},
    "/sport/contact.app" => %{location: "/send/u49719405", status: 301},
    "/sport/cricket/53783524" => %{location: "/sport/cricket/teams", status: 301},
    "/sport/cricket/53783524.app" => %{location: "/sport/cricket/teams.app", status: 301},
    "/sport/darts/19333759" => %{location: "/sport/ice-hockey/results", status: 301},
    "/sport/darts/19333759.app" => %{location: "/sport/ice-hockey/results.app", status: 301},
    "/sport/disability-sport/paralympics-2012" => %{location: "/sport/disability-sport", status: 301},
    "/sport/disability-sport/paralympics-2012.app" => %{location: "/sport/disability-sport.app", status: 301},
    "/sport/football/53783525" => %{location: "/sport/football/leagues-cups", status: 301},
    "/sport/football/53783525.app" => %{location: "/sport/football/leagues-cups.app", status: 301},
    "/sport/football/53783521" => %{location: "/sport/football/teams", status: 301},
    "/sport/football/53783521.app" => %{location: "/sport/football/teams.app", status: 301},
    "/sport/football/african" => %{location: "/sport/africa", status: 301},
    "/sport/football/african.app" => %{location: "/sport/africa.app", status: 301},
    "/sport/football/european-championship/2012" => %{location: "/sport/football/european-championship", status: 301},
    "/sport/football/european-championship/2012.app" => %{
      location: "/sport/football/european-championship.app",
      status: 301
    },
    "/sport/football/european-championship/2016" => %{location: "/sport/football/european-championship", status: 301},
    "/sport/football/european-championship/2016.app" => %{
      location: "/sport/football/european-championship.app",
      status: 301
    },
    "/sport/football/european-championship/euro-2016/video" => %{
      location: "/sport/football/european-championship/video",
      status: 301
    },
    "/sport/football/european-championship/euro-2016/video.app" => %{
      location: "/sport/football/european-championship/video.app",
      status: 301
    },
    "/sport/football/european-championship/euro-2016" => %{
      location: "/sport/football/european-championship",
      status: 301
    },
    "/sport/football/european-championship/euro-2016.app" => %{
      location: "/sport/football/european-championship.app",
      status: 301
    },
    "/sport/football/european-championship/fixtures" => %{
      location: "/sport/football/european-championship/scores-fixtures",
      status: 301
    },
    "/sport/football/european-championship/fixtures.app" => %{
      location: "/sport/football/european-championship/scores-fixtures.app",
      status: 301
    },
    "/sport/football/european-championship/schedule" => %{
      location: "/sport/football/european-championship",
      status: 302
    },
    "/sport/football/european-championship/schedule.app" => %{
      location: "/sport/football/european-championship.app",
      status: 302
    },
    "/sport/football/supermovers" => %{location: "/teach/supermovers", status: 301},
    "/sport/football/supermovers.app" => %{location: "/teach/supermovers", status: 301},
    "/sport/football/world-cup/schedule" => %{location: "/sport/football/world-cup", status: 302},
    "/sport/football/world-cup/schedule.app" => %{location: "/sport/football/world-cup.app", status: 302},
    "/sport/formula1/standings" => %{location: "/sport/formula1/drivers-world-championship/standings", status: 302},
    "/sport/formula1/standings.app" => %{
      location: "/sport/formula1/drivers-world-championship/standings.app",
      status: 302
    },
    "/sport/front-page" => %{location: "/sport", status: 301},
    "/sport/front-page.app" => %{location: "/sport.app", status: 301},
    "/sport/get-inspired/bodypositive" => %{location: "/sport/get-inspired", status: 301},
    "/sport/get-inspired/bodypositive.app" => %{location: "/sport/get-inspired.app", status: 301},
    "/sport/get-inspired/fa-peoples-cup" => %{location: "/sport/get-inspired", status: 301},
    "/sport/get-inspired/fa-peoples-cup.app" => %{location: "/sport/get-inspired.app", status: 301},
    "/sport/get-inspired/unsung-heroes" => %{location: "/sport/get-inspired", status: 301},
    "/sport/get-inspired/unsung-heroes.app" => %{location: "/sport/get-inspired.app", status: 301},
    "/sport/olympics/2012" => %{location: "/sport/olympics", status: 301},
    "/sport/olympics/2012.app" => %{location: "/sport/olympics.app", status: 301},
    "/sport/olympics/2016" => %{location: "/sport/olympics", status: 301},
    "/sport/olympics/2016.app" => %{location: "/sport/olympics.app", status: 301},
    "/sport/olympics/rio-2016/video" => %{location: "/sport/olympics/video", status: 301},
    "/sport/olympics/rio-2016/video.app" => %{location: "/sport/olympics/video.app", status: 301},
    "/sport/olympics/rio-2016" => %{location: "/sport/olympics", status: 301},
    "/sport/olympics/rio-2016.app" => %{location: "/sport/olympics.app", status: 301},
    "/sport/paralympics/rio-2016/medals" => %{location: "/sport/disability-sport", status: 301},
    "/sport/paralympics/rio-2016/medals.app" => %{location: "/sport/disability-sport.app", status: 301},
    "/sport/paralympics/rio-2016/schedule" => %{location: "/sport/disability-sport", status: 301},
    "/sport/paralympics/rio-2016/schedule.app" => %{location: "/sport/disability-sport.app", status: 301},
    "/sport/rugby-league/53783522" => %{location: "/sport/rugby-league/teams", status: 301},
    "/sport/rugby-league/53783522.app" => %{location: "/sport/rugby-league/teams.app", status: 301},
    "/sport/rugby-union/53783523" => %{location: "/sport/rugby-union/teams", status: 301},
    "/sport/rugby-union/53783523.app" => %{location: "/sport/rugby-union/teams.app", status: 301},
    "/sport/supermovers/42612496" => %{location: "/teach/supermovers/ks1-collection/zbr4scw", status: 301},
    "/sport/supermovers/42612496.app" => %{location: "/teach/supermovers/ks1-collection/zbr4scw", status: 301},
    "/sport/supermovers/42612499" => %{location: "/teach/supermovers/ks2-collection/zr4ky9q", status: 301},
    "/sport/supermovers/42612499.app" => %{location: "/teach/supermovers/ks2-collection/zr4ky9q", status: 301},
    "/sport/supermovers/42612500" => %{location: "/teach/supermovers/cymru/zkdjgwx", status: 301},
    "/sport/supermovers/42612500.app" => %{location: "/teach/supermovers/cymru/zkdjgwx", status: 301},
    "/sport/supermovers/42612503" => %{location: "/teach/supermovers/just-for-fun-collection/z7tymfr", status: 301},
    "/sport/supermovers/42612503.app" => %{location: "/teach/supermovers/just-for-fun-collection/z7tymfr", status: 301},
    "/sport/supermovers/12345678" => %{location: "/teach/supermovers", status: 301},
    "/sport/supermovers/12345678.app" => %{location: "/teach/supermovers", status: 301},
    "/sport/winter-olympics/home-nations" => %{location: "/sport/winter-olympics", status: 302},
    "/sport/winter-olympics/home-nations.app" => %{location: "/sport/winter-olympics.app", status: 302},
    "/sport/winter-olympics/medals" => %{location: "/sport/winter-olympics", status: 302},
    "/sport/winter-olympics/medals.app" => %{location: "/sport/winter-olympics.app", status: 302},
    "/sport/winter-olympics/results" => %{location: "/sport/winter-olympics", status: 302},
    "/sport/winter-olympics/results.app" => %{location: "/sport/winter-olympics.app", status: 302},
    "/sport/winter-olympics/schedule" => %{location: "/sport/winter-olympics", status: 302},
    "/sport/winter-olympics/schedule.app" => %{location: "/sport/winter-olympics.app", status: 302},
    "/sport/winter-olympics/sports" => %{location: "/sport/winter-olympics", status: 302},
    "/sport/winter-olympics/sports.app" => %{location: "/sport/winter-olympics.app", status: 302}
  }

  @regex_paths %{
    ~r{/sport/commonwealth-games/(medals|results|schedule)/.*.app$} => %{
      location: "/sport/commonwealth-games.app",
      status: 302
    },
    ~r{/sport/commonwealth-games/(medals|results|schedule)/.*(?<!\.app)$} => %{
      location: "/sport/commonwealth-games",
      status: 302
    },
    ~r{/sport/football/european-championship/euro-2016/.*.app$} => %{
      location: "/sport/football/european-championship.app",
      status: 301
    },
    ~r{/sport/football/european-championship/euro-2016/.*(?<!\.app)$} => %{
      location: "/sport/football/european-championship",
      status: 301
    },
    ~r{/sport/football/european-championship/schedule/.*.app$} => %{
      location: "/sport/football/european-championship.app",
      status: 302
    },
    ~r{/sport/football/european-championship/schedule/.*(?<!\.app)$} => %{
      location: "/sport/football/european-championship",
      status: 302
    },
    ~r{/sport/football/world-cup/schedule/.*.app$} => %{location: "/sport/football/world-cup.app", status: 302},
    ~r{/sport/football/world-cup/schedule/.*(?<!\.app)$} => %{location: "/sport/football/world-cup", status: 302},
    ~r{/sport/olympics/2012/.*.app$} => %{location: "/sport/olympics.app", status: 301},
    ~r{/sport/olympics/2012/.*(?<!\.app)$} => %{location: "/sport/olympics", status: 301},
    ~r{/sport/olympics/2016/.*.app$} => %{location: "/sport/olympics.app", status: 301},
    ~r{/sport/olympics/2016/.*(?<!\.app)$} => %{location: "/sport/olympics", status: 301},
    ~r{/sport/olympics/rio-2016/.*.app$} => %{location: "/sport/olympics.app", status: 301},
    ~r{/sport/olympics/rio-2016/.*(?<!\.app)$} => %{location: "/sport/olympics", status: 301},
    ~r{/sport/paralympics/rio-2016/medals/.*.app$} => %{location: "/sport/disability-sport.app", status: 301},
    ~r{/sport/paralympics/rio-2016/medals/.*(?<!\.app)$} => %{location: "/sport/disability-sport", status: 301},
    ~r{/sport/paralympics/rio-2016/schedule/.*.app$} => %{location: "/sport/disability-sport.app", status: 301},
    ~r{/sport/paralympics/rio-2016/schedule/.*(?<!\.app)$} => %{location: "/sport/disability-sport", status: 301},
    ~r{/sport/winter-olympics/(medals|results|schedule)/.*.app$} => %{
      location: "/sport/winter-olympics.app",
      status: 302
    },
    ~r{/sport/winter-olympics/(medals|results|schedule)/.*(?<!\.app)$} => %{
      location: "/sport/winter-olympics",
      status: 302
    }
  }

  def call(rest, struct) do
    location = @absolute_paths[struct.request.path] || redirect_to(struct.request.path)

    case location !== nil do
      true -> redirect(location, struct)
      _ -> then(rest, struct)
    end
  end

  def redirect_to(path) do
    case Enum.find(@regex_paths, nil, fn {key, _val} -> String.match?(path, key) end) do
      nil -> nil
      {_key, val} -> val
    end
  end

  def redirect(%{location: location, status: 301}, struct) do
    {
      :redirect,
      Struct.add(struct, :response, %{
        http_status: 301,
        headers: %{
          "location" => location,
          "x-bbc-no-scheme-rewrite" => "1",
          "cache-control" => "public, stale-while-revalidate=10, max-age=3600"
        },
        body: "Redirecting"
      })
    }
  end

  def redirect(%{location: location, status: 302}, struct) do
    {
      :redirect,
      Struct.add(struct, :response, %{
        http_status: 302,
        headers: %{
          "location" => location,
          "x-bbc-no-scheme-rewrite" => "1",
          "cache-control" => "public, stale-while-revalidate=10, max-age=600"
        },
        body: "Redirecting"
      })
    }
  end
end
