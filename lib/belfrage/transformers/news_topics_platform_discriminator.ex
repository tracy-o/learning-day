defmodule Belfrage.Transformers.NewsTopicsPlatformDiscriminator do
  @moduledoc """
  Alters the Platform and Origin for a subset of News Topics IDs that need to be served by Webcore.
  """
  use Belfrage.Transformers.Transformer

  @webcore_ids [
    "cl16knzkz9yt",
    "cl16knz07e2t",
    "c8qx38n5jzlt",
    "c5yd7pzx95qt",
    "c8qx38n5vy0t",
    "cvrkv4x14jkt",
    "cyzpjd57213t",
    "cqypkzl5xvrt",
    "c5yd7pzx3yyt",
    "c2e418dqpkkt",
    "c5yd7pzxne0t",
    "c63d8496d2nt",
    "cr3pkx7v1d1t",
    "cd61kenlzv7t",
    "c1l7jeydv1jt",
    "c01e2673yydt",
    "c5yd7pzxek8t",
    "c63d8496r06t",
    "cezlkpje5zkt",
    "c63d8496ky9t",
    "ckj6kvxqrppt",
    "cr3pkx7vy68t",
    "c909dyjvdk2t",
    "c8xk6e03epdt",
    "c5yd7pzxxrpt",
    "cyzpjd57zpxt",
    "c48de9xr454t",
    "cezlkpjenj7t",
    "c63d84969y6t",
    "c1l7jeylnv1t",
    "cvrkv4xr93pt",
    "cj26k502xxzt",
    "c48de9x8yrpt",
    "cl16knz1d2lt",
    "cj26k502561t",
    "cne6kq5e00pt",
    "cezlkpjzdjzt",
    "cn5e8npr2l3t",
    "czpd19nplk7t",
    "c8qx38nq177t",
    "c8qx38nqx4qt",
    "cne6kq5evr5t",
    "cvrkv4xr81qt",
    "c2e418d0zxqt",
    "cezlkpjzx2jt",
    "c7d9y05d1lnt",
    "c63d84937ejt",
    "c37dl8076jxt",
    "cx6p27961e1t",
    "c1l7jeylzr3t",
    "c5yd7pzy8d8t",
    "cyzpjd5z4d3t",
    "c7d9y05dy70t",
    "cr3pkx73kv3t",
    "c63d84936vyt",
    "cvrkv4xrr7kt",
    "c909dyj052rt",
    "cne6kq5e5r0t",
    "cmwjjp141ydt",
    "cj26k50er7xt",
    "cp86kdjq015t",
    "cezlkpjn4v7t",
    "c01e267d41jt",
    "cne6kq53z8dt",
    "c909dyj5y94t",
    "cne6kq5300nt",
    "c01e267dpvrt",
    "cezlkpjn5x5t",
    "cx6p2795jvqt",
    "cl16knz857vt",
    "c8qx38n91kkt",
    "cp86kdjq6p0t",
    "ckj6kvx762pt",
    "c8qx38n9el2t",
    "cj26k50e9pet",
    "ckj6kvx7pdyt",
    "cvrkv4xp7ret",
    "cqypkzl0n79t",
    "cl1gj7nz0l0t",
    "cl1gj7x2986t",
    "ck7l4e11g49t"
  ]

  @impl true
  def call(rest, struct) do
    case Enum.member?(@webcore_ids, struct.request.path_params["id"]) do
      true ->
        then(
          rest,
          Struct.add(struct, :private, %{
            platform: Webcore,
            origin: Application.get_env(:belfrage, :pwa_lambda_function)
          })
        )

      false ->
        then(rest, struct)
    end
  end
end
