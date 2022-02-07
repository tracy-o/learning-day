defmodule Belfrage.Transformers.NewsTopicsPlatformDiscriminator do
  @moduledoc """
  Alters the Platform for a subset of News Topics IDs that need to be served by Mozart.
  """
  use Belfrage.Transformers.Transformer

  @webcore_ids [
    # Allegra Stratton | BBC News
    "cl16knzkz9yt",
    # Amol Rajan | BBC News
    "cl16knz07e2t",
    # Andrew Harding | BBC News
    "c8qx38n5jzlt",
    # Andrew Neil | BBC News
    "c5yd7pzx95qt",
    # Andrew North | BBC News
    "c8qx38n5vy0t",
    # Anthony Zurcher | BBC News
    "cvrkv4x14jkt",
    # Arif Ansari | BBC News
    "cyzpjd57213t",
    # Betsan Powys | BBC News
    "cqypkzl5xvrt",
    # Branwen Jeffreys | BBC News
    "c5yd7pzx3yyt",
    # Brian Taylor | BBC News
    "c2e418dqpkkt",
    # Chris Cook | BBC News
    "c5yd7pzxne0t",
    # Chris Jackson | BBC News
    "c63d8496d2nt",
    # Damian Grammaticas | BBC News
    "cr3pkx7v1d1t",
    # Danny Shaw | BBC News
    "cd61kenlzv7t",
    # David Cornock | BBC News
    "c1l7jeydv1jt",
    # David Gregory-Kumar | BBC News
    "c01e2673yydt",
    # David Shukman | BBC News
    "c5yd7pzxek8t",
    # Deborah McGurran | BBC News
    "c63d8496r06t",
    # Dominic Casciani | BBC News
    "cezlkpje5zkt",
    # Douglas Fraser | BBC News
    "c63d8496ky9t",
    # Duncan Weldon | BBC News
    "ckj6kvxqrppt",
    # Emily Maitlis | BBC News
    "cr3pkx7vy68t",
    # Faisal Islam | BBC News
    "c909dyjvdk2t",
    # Fergus Walsh, medical editor | BBC News
    "c8xk6e03epdt",
    # Gavin Hewitt | BBC News
    "c5yd7pzxxrpt",
    # Gordon Corera | BBC News
    "cyzpjd57zpxt",
    # Helen Thomas | BBC News
    "c48de9xr454t",
    # Hugh Pym | BBC News
    "cezlkpjenj7t",
    # James Landale | BBC News
    "c63d84969y6t",
    # Jawad Iqbal | BBC News
    "c1l7jeylnv1t",
    # John Hess | BBC News
    "cvrkv4xr93pt",
    # John Simpson | BBC News
    "cj26k502xxzt",
    # Jon Donnison | BBC News
    "c48de9x8yrpt",
    # Jon Sopel | BBC News
    "cl16knz1d2lt",
    # Jonathan Amos | BBC News
    "cj26k502561t",
    # Jonathan Marcus | BBC News
    "cne6kq5e00pt",
    # Jonny Dymond | BBC News
    "cezlkpjzdjzt",
    # Justin Rowlatt, climate editor | BBC News
    "cn5e8npr2l3t",
    # Kamal Ahmed | BBC News
    "czpd19nplk7t",
    # Karishma Vaswani | BBC News
    "c8qx38nq177t",
    # Katty Kay | BBC News
    "c8qx38nqx4qt",
    # Katya Adler | BBC News
    "cne6kq5evr5t",
    # Laura Kuenssberg | BBC News
    "cvrkv4xr81qt",
    # Lyse Doucet | BBC News
    "c2e418d0zxqt",
    # Mark D'Arcy | BBC News
    "cezlkpjzx2jt",
    # Mark Devenport | BBC News
    "c7d9y05d1lnt",
    # Mark Easton | BBC News
    "c63d84937ejt",
    # Mark Mardell | BBC News
    "c37dl8076jxt",
    # Martin Rosenbaum | BBC News
    "cx6p27961e1t",
    # Mark Urban | BBC News
    "c1l7jeylzr3t",
    # Martyn Oates | BBC News
    "c5yd7pzy8d8t",
    # Matt McGrath | BBC News
    "cyzpjd5z4d3t",
    # Michael Crick | BBC News
    "c7d9y05dy70t",
    # Nicholas Watt | BBC News
    "cr3pkx73kv3t",
    # Nick Bryant | BBC News
    "c63d84936vyt",
    # Nick Robinson | BBC News
    "cvrkv4xrr7kt",
    # Nick Servini | BBC News
    "c909dyj052rt",
    # Nick Triggle | BBC News
    "cne6kq5e5r0t",
    # Nikki Fox, disability correspondent | BBC News
    "cmwjjp141ydt",
    # Patrick Burns | BBC News
    "cj26k50er7xt",
    # Paul Barltrop | BBC News
    "cp86kdjq015t",
    # Peter Henley | BBC News
    "cezlkpjn4v7t",
    # Peter Hunt | BBC News
    "c01e267d41jt",
    # Phil Coomes | BBC News
    "cne6kq53z8dt",
    # Richard Moss | BBC News
    "c909dyj5y94t",
    # Robert Peston | BBC News
    "cne6kq5300nt",
    # Rory Cellan-Jones | BBC News
    "c01e267dpvrt",
    # Sarah Smith | BBC News
    "cezlkpjn5x5t",
    # Sean Coughlan | BBC News
    "cx6p2795jvqt",
    # Simon Jack | BBC News
    "cl16knz857vt",
    # Soutik Biswas | BBC News
    "c8qx38n91kkt",
    # Tim Iredale | BBC News
    "cp86kdjq6p0t",
    # Tom Edwards | BBC News
    "ckj6kvx762pt",
    # Tom Feilden | BBC News
    "c8qx38n9el2t",
    # Tony Roe | BBC News
    "cj26k50e9pet",
    # Vaughan Roderick | BBC News
    "ckj6kvx7pdyt",
    # Will Gompertz | BBC News
    "cvrkv4xp7ret",
    # Wyre Davies | BBC News
    "cqypkzl0n79t",
    # Ben Hunte, West Africa correspondent | BBC News
    "cl1gj7nz0l0t",
    # Cherry Wilson, BBC News senior reporter | BBC News
    "cl1gj7x2986t",
    # Dr Faye Kirkland | BBC News
    "ck7l4e11g49t",
    # BBC Trending | BBC News
    "cme72mv58q4t",
    # The Papers | BBC News
    "cpml2v678pxt",
    # Scotland's Newspaper review | BBC News
    "cn7qzpd3gzgt",
    # Northern Ireland Newspaper review | BBC News
    "c4mr5v9znzqt"
  ]

  def call(
        _rest,
        struct = %Struct{request: %Struct.Request{path_params: %{"id" => id, "slug" => _slug}}}
      )
      when id in @webcore_ids do
    {
      :redirect,
      Struct.add(struct, :response, %{
        http_status: 302,
        headers: %{
          "location" => "/news/topics/#{id}",
          "x-bbc-no-scheme-rewrite" => "1",
          "cache-control" => "public, stale-while-revalidate=10, max-age=60"
        },
        body: "Redirecting"
      })
    }
  end

  def call(_rest, struct = %Struct{request: %Struct.Request{path_params: %{"id" => id}}}) when id not in @webcore_ids do
    then(
      ["CircuitBreaker"],
      Struct.add(struct, :private, %{
        platform: MozartNews
      })
    )
  end
end
