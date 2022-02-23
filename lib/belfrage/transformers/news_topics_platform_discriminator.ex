defmodule Belfrage.Transformers.NewsTopicsPlatformDiscriminator do
  @moduledoc """
  Alters the Platform for a subset of News Topics IDs that need to be served by Mozart.
  """
  use Belfrage.Transformers.Transformer

  @webcore_ids [
    # Allegra Stratton
    "cl16knzkz9yt",
    # Amol Rajan
    "cl16knz07e2t",
    # Andrew Harding
    "c8qx38n5jzlt",
    # Andrew Neil
    "c5yd7pzx95qt",
    # Andrew North
    "c8qx38n5vy0t",
    # Anthony Zurcher
    "cvrkv4x14jkt",
    # Arif Ansari
    "cyzpjd57213t",
    # Betsan Powys
    "cqypkzl5xvrt",
    # Branwen Jeffreys
    "c5yd7pzx3yyt",
    # Brian Taylor
    "c2e418dqpkkt",
    # Chris Cook
    "c5yd7pzxne0t",
    # Chris Jackson
    "c63d8496d2nt",
    # Damian Grammaticas
    "cr3pkx7v1d1t",
    # Danny Shaw
    "cd61kenlzv7t",
    # David Cornock
    "c1l7jeydv1jt",
    # David Gregory-Kumar
    "c01e2673yydt",
    # David Shukman
    "c5yd7pzxek8t",
    # Deborah McGurran
    "c63d8496r06t",
    # Dominic Casciani
    "cezlkpje5zkt",
    # Douglas Fraser
    "c63d8496ky9t",
    # Duncan Weldon
    "ckj6kvxqrppt",
    # Emily Maitlis
    "cr3pkx7vy68t",
    # Faisal Islam
    "c909dyjvdk2t",
    # Fergus Walsh, medical editor
    "c8xk6e03epdt",
    # Gavin Hewitt
    "c5yd7pzxxrpt",
    # Gordon Corera
    "cyzpjd57zpxt",
    # Helen Thomas
    "c48de9xr454t",
    # Hugh Pym
    "cezlkpjenj7t",
    # James Landale
    "c63d84969y6t",
    # Jawad Iqbal
    "c1l7jeylnv1t",
    # John Hess
    "cvrkv4xr93pt",
    # John Simpson
    "cj26k502xxzt",
    # Jon Donnison
    "c48de9x8yrpt",
    # Jon Sopel
    "cl16knz1d2lt",
    # Jonathan Amos
    "cj26k502561t",
    # Jonathan Marcus
    "cne6kq5e00pt",
    # Jonny Dymond
    "cezlkpjzdjzt",
    # Justin Rowlatt, climate editor
    "cn5e8npr2l3t",
    # Kamal Ahmed
    "czpd19nplk7t",
    # Karishma Vaswani
    "c8qx38nq177t",
    # Katty Kay
    "c8qx38nqx4qt",
    # Katya Adler
    "cne6kq5evr5t",
    # Laura Kuenssberg
    "cvrkv4xr81qt",
    # Lyse Doucet
    "c2e418d0zxqt",
    # Mark D'Arcy
    "cezlkpjzx2jt",
    # Mark Devenport
    "c7d9y05d1lnt",
    # Mark Easton
    "c63d84937ejt",
    # Mark Mardell
    "c37dl8076jxt",
    # Martin Rosenbaum
    "cx6p27961e1t",
    # Mark Urban
    "c1l7jeylzr3t",
    # Martyn Oates
    "c5yd7pzy8d8t",
    # Matt McGrath
    "cyzpjd5z4d3t",
    # Michael Crick
    "c7d9y05dy70t",
    # Nicholas Watt
    "cr3pkx73kv3t",
    # Nick Bryant
    "c63d84936vyt",
    # Nick Robinson
    "cvrkv4xrr7kt",
    # Nick Servini
    "c909dyj052rt",
    # Nick Triggle
    "cne6kq5e5r0t",
    # Nikki Fox, disability correspondent
    "cmwjjp141ydt",
    # Patrick Burns
    "cj26k50er7xt",
    # Paul Barltrop
    "cp86kdjq015t",
    # Peter Henley
    "cezlkpjn4v7t",
    # Peter Hunt
    "c01e267d41jt",
    # Phil Coomes
    "cne6kq53z8dt",
    # Richard Moss
    "c909dyj5y94t",
    # Robert Peston
    "cne6kq5300nt",
    # Rory Cellan-Jones
    "c01e267dpvrt",
    # Sarah Smith
    "cezlkpjn5x5t",
    # Sean Coughlan
    "cx6p2795jvqt",
    # Simon Jack
    "cl16knz857vt",
    # Soutik Biswas
    "c8qx38n91kkt",
    # Tim Iredale
    "cp86kdjq6p0t",
    # Tom Edwards
    "ckj6kvx762pt",
    # Tom Feilden
    "c8qx38n9el2t",
    # Tony Roe
    "cj26k50e9pet",
    # Vaughan Roderick
    "ckj6kvx7pdyt",
    # Will Gompertz
    "cvrkv4xp7ret",
    # Wyre Davies
    "cqypkzl0n79t",
    # Ben Hunte, West Africa correspondent
    "cl1gj7nz0l0t",
    # Cherry Wilson, BBC News senior reporter
    "cl1gj7x2986t",
    # Dr Faye Kirkland
    "ck7l4e11g49t",
    # BBC Trending
    "cme72mv58q4t",
    # The Papers
    "cpml2v678pxt",
    # Scotland's Newspaper review
    "cn7qzpd3gzgt",
    # Northern Ireland Newspaper review
    "c4mr5v9znzqt"
  ]

  def call(_rest, struct) do
    cond do
      redirect?(struct) ->
        {
          :redirect,
          Struct.add(struct, :response, %{
            http_status: 302,
            headers: %{
              "location" => "/news/topics/#{struct.request.path_params["id"]}",
              "x-bbc-no-scheme-rewrite" => "1",
              "cache-control" => "public, stale-while-revalidate=10, max-age=60"
            },
            body: "Redirecting"
          })
        }

      to_mozart_news?(struct) ->
        then_do(
          ["CircuitBreaker"],
          Struct.add(struct, :private, %{
            platform: MozartNews,
            origin: Application.get_env(:belfrage, :mozart_news_endpoint)
          })
        )

      to_webcore?(struct) ->
        then_do(
          ["CircuitBreaker"],
          Struct.add(struct, :private, %{
            platform: Webcore,
            origin: Application.get_env(:belfrage, :pwa_lambda_function)
          })
        )

      true ->
        then_do([], struct)
    end
  end

  defp redirect?(struct) do
    struct.request.path_params["id"] in @webcore_ids and Map.has_key?(struct.request.path_params, "slug")
  end

  defp to_webcore?(struct) do
    struct.request.path_params["id"] in @webcore_ids and not Map.has_key?(struct.request.path_params, "slug")
  end

  defp to_mozart_news?(struct) do
    struct.request.path_params["id"] not in @webcore_ids
  end
end
