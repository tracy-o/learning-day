defmodule Belfrage.Transformers.SportRedirect do
  use Belfrage.Transformers.Transformer

  @regex_paths %{
    ~r"/sport/commonwealth-games/(medals|results|schedule)/.*.app$" => %{
      location: "/sport/commonwealth-games.app",
      status: 302
    },
    ~r"/sport/commonwealth-games/(medals|results|schedule)/.*(?<!\.app)$" => %{
      location: "/sport/commonwealth-games",
      status: 302
    },
    ~r"/sport/commonwealth-games/(home-nations|medals|results|schedule|sports).app$" => %{
      location: "/sport/commonwealth-games.app",
      status: 302
    },
    ~r"/sport/commonwealth-games/(home-nations|medals|results|schedule|sports)$" => %{
      location: "/sport/commonwealth-games",
      status: 302
    },
    ~r"/sport/football/european-championship/(2012|2016).app$" => %{
      location: "/sport/football/european-championship.app",
      status: 301
    },
    ~r"/sport/football/european-championship/(2012|2016)$" => %{
      location: "/sport/football/european-championship",
      status: 301
    },
    ~r"/sport/football/european-championship/schedule(/.*)?.app$" => %{
      location: "/sport/football/european-championship.app",
      status: 302
    },
    ~r"/sport/football/european-championship/schedule(/.*)?(?<!\.app)$" => %{
      location: "/sport/football/european-championship",
      status: 302
    },
    ~r"/sport/football/european-championship/euro-2016(/.*)?.app$" => %{
      location: "/sport/football/european-championship.app",
      status: 301
    },
    ~r"/sport/football/european-championship/euro-2016(/.*)?(?<!\.app)$" => %{
      location: "/sport/football/european-championship",
      status: 301
    },
    ~r"/sport/football/world-cup/schedule(/.*)?.app$" => %{location: "/sport/football/world-cup.app", status: 302},
    ~r"/sport/football/world-cup/schedule(/.*)?(?<!\.app)$" => %{location: "/sport/football/world-cup", status: 302},
    ~r"/sport/olympics/2012(/.*)?.app$" => %{location: "/sport/olympics.app", status: 301},
    ~r"/sport/olympics/2012(/.*)?(?<!\.app)$" => %{location: "/sport/olympics", status: 301},
    ~r"/sport/olympics/2016(/.*)?.app$" => %{location: "/sport/olympics.app", status: 301},
    ~r"/sport/olympics/2016(/.*)?(?<!\.app)$" => %{location: "/sport/olympics", status: 301},
    ~r"/sport/olympics/rio-2016(/.*)?.app$" => %{location: "/sport/olympics.app", status: 301},
    ~r"/sport/olympics/rio-2016(/.*)?(?<!\.app)$" => %{location: "/sport/olympics", status: 301},
    ~r"/sport/paralympics/rio-2016/(medals|schedule)(/.*)?.app$" => %{
      location: "/sport/disability-sport.app",
      status: 301
    },
    ~r"/sport/paralympics/rio-2016/(medals|schedule)(/.*)?(?<!\.app)$" => %{
      location: "/sport/disability-sport",
      status: 301
    },
    ~r"/sport/winter-olympics/(medals|results|schedule)/.*.app$" => %{
      location: "/sport/winter-olympics.app",
      status: 302
    },
    ~r"/sport/winter-olympics/(medals|results|schedule)/.*(?<!\.app)$" => %{
      location: "/sport/winter-olympics",
      status: 302
    },
    ~r"/sport/winter-olympics/(home-nations|medals|results|schedule|sports).app$" => %{
      location: "/sport/winter-olympics.app",
      status: 302
    },
    ~r"/sport/winter-olympics/(home-nations|medals|results|schedule|sports)$" => %{
      location: "/sport/winter-olympics",
      status: 302
    }
  }

  def call(rest, struct) do
    location = redirect_to(struct.request.path)

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

  def redirect(%{location: location, status: status}, struct) do
    {
      :redirect,
      Struct.add(struct, :response, %{
        http_status: status,
        headers: %{
          "location" => location,
          "x-bbc-no-scheme-rewrite" => "1",
          "cache-control" => "public, stale-while-revalidate=10, max-age=3600"
        },
        body: "Redirecting"
      })
    }
  end
end
