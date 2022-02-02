defmodule Belfrage.Transformers.NewsTopicsPlatformDiscriminator do
  @moduledoc """
  Alters the Platform for a subset of News Topics IDs that need to be served by Mozart.
  """
  use Belfrage.Transformers.Transformer

  @webcore_ids [
    "cl16knzkz9yt", # Allegra Stratton | BBC News
    "cl16knz07e2t", # Amol Rajan | BBC News
    "c8qx38n5jzlt", # Andrew Harding | BBC News
    "c5yd7pzx95qt", # Andrew Neil | BBC News
    "c8qx38n5vy0t", # Andrew North | BBC News
    "cvrkv4x14jkt", # Anthony Zurcher | BBC News
    "cyzpjd57213t", # Arif Ansari | BBC News
    "cqypkzl5xvrt", # Betsan Powys | BBC News
    "c5yd7pzx3yyt", # Branwen Jeffreys | BBC News
    "c2e418dqpkkt", # Brian Taylor | BBC News
    "c5yd7pzxne0t", # Chris Cook | BBC News
    "c63d8496d2nt", # Chris Jackson | BBC News
    "cr3pkx7v1d1t", # Damian Grammaticas | BBC News
    "cd61kenlzv7t", # Danny Shaw | BBC News
    "c1l7jeydv1jt", # David Cornock | BBC News
    "c01e2673yydt", # David Gregory-Kumar | BBC News
    "c5yd7pzxek8t", # David Shukman | BBC News
    "c63d8496r06t", # Deborah McGurran | BBC News
    "cezlkpje5zkt", # Dominic Casciani | BBC News
    "c63d8496ky9t", # Douglas Fraser | BBC News
    "ckj6kvxqrppt", # Duncan Weldon | BBC News
    "cr3pkx7vy68t", # Emily Maitlis | BBC News
    "c909dyjvdk2t", # Faisal Islam | BBC News
    "c8xk6e03epdt", # Fergus Walsh, medical editor | BBC News
    "c5yd7pzxxrpt", # Gavin Hewitt | BBC News
    "cyzpjd57zpxt", # Gordon Corera | BBC News
    "c48de9xr454t", # Helen Thomas | BBC News
    "cezlkpjenj7t", # Hugh Pym | BBC News
    "c63d84969y6t", # James Landale | BBC News
    "c1l7jeylnv1t", # Jawad Iqbal | BBC News
    "cvrkv4xr93pt", # John Hess | BBC News
    "cj26k502xxzt", # John Simpson | BBC News
    "c48de9x8yrpt", # Jon Donnison | BBC News
    "cl16knz1d2lt", # Jon Sopel | BBC News
    "cj26k502561t", # Jonathan Amos | BBC News
    "cne6kq5e00pt", # Jonathan Marcus | BBC News
    "cezlkpjzdjzt", # Jonny Dymond | BBC News
    "cn5e8npr2l3t", # Justin Rowlatt, climate editor | BBC News
    "czpd19nplk7t", # Kamal Ahmed | BBC News
    "c8qx38nq177t", # Karishma Vaswani | BBC News
    "c8qx38nqx4qt", # Katty Kay | BBC News
    "cne6kq5evr5t", # Katya Adler | BBC News
    "cvrkv4xr81qt", # Laura Kuenssberg | BBC News
    "c2e418d0zxqt", # Lyse Doucet | BBC News
    "cezlkpjzx2jt", # Mark D'Arcy | BBC News
    "c7d9y05d1lnt", # Mark Devenport | BBC News
    "c63d84937ejt", # Mark Easton | BBC News
    "c37dl8076jxt", # Mark Mardell | BBC News
    "cx6p27961e1t", # Martin Rosenbaum | BBC News
    "c1l7jeylzr3t", # Mark Urban | BBC News
    "c5yd7pzy8d8t", # Martyn Oates | BBC News
    "cyzpjd5z4d3t", # Matt McGrath | BBC News
    "c7d9y05dy70t", # Michael Crick | BBC News
    "cr3pkx73kv3t", # Nicholas Watt | BBC News
    "c63d84936vyt", # Nick Bryant | BBC News
    "cvrkv4xrr7kt", # Nick Robinson | BBC News
    "c909dyj052rt", # Nick Servini | BBC News
    "cne6kq5e5r0t", # Nick Triggle | BBC News
    "cmwjjp141ydt", # Nikki Fox, disability correspondent | BBC News
    "cj26k50er7xt", # Patrick Burns | BBC News
    "cp86kdjq015t", # Paul Barltrop | BBC News
    "cezlkpjn4v7t", # Peter Henley | BBC News
    "c01e267d41jt", # Peter Hunt | BBC News
    "cne6kq53z8dt", # Phil Coomes | BBC News
    "c909dyj5y94t", # Richard Moss | BBC News
    "cne6kq5300nt", # Robert Peston | BBC News
    "c01e267dpvrt", # Rory Cellan-Jones | BBC News
    "cezlkpjn5x5t", # Sarah Smith | BBC News
    "cx6p2795jvqt", # Sean Coughlan | BBC News
    "cl16knz857vt", # Simon Jack | BBC News
    "c8qx38n91kkt", # Soutik Biswas | BBC News
    "cp86kdjq6p0t", # Tim Iredale | BBC News
    "ckj6kvx762pt", # Tom Edwards | BBC News
    "c8qx38n9el2t", # Tom Feilden | BBC News
    "cj26k50e9pet", # Tony Roe | BBC News
    "ckj6kvx7pdyt", # Vaughan Roderick | BBC News
    "cvrkv4xp7ret", # Will Gompertz | BBC News
    "cqypkzl0n79t", # Wyre Davies | BBC News
    "cl1gj7nz0l0t", # Ben Hunte, West Africa correspondent | BBC News
    "cl1gj7x2986t", # Cherry Wilson, BBC News senior reporter | BBC News
    "ck7l4e11g49t", # Dr Faye Kirkland | BBC News
    "cme72mv58q4t", # BBC Trending | BBC News
    "cpml2v678pxt", # The Papers | BBC News
    "cn7qzpd3gzgt", # Scotland's Newspaper review | BBC News
    "c4mr5v9znzqt", # Northern Ireland Newspaper review | BBC News
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
