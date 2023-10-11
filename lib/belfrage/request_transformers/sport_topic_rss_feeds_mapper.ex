defmodule Belfrage.RequestTransformers.SportTopicRssFeedsMapper do
  @moduledoc """
  Does the mapping between path and topicId.
  Alters the Platform for a subset of Sport RSS feeds that need to be served by FABL.
  """
  use Belfrage.Behaviours.Transformer

  @sport_feed_mapping %{
    "/sport/rss.xml" => "c22ymglr3x3t",
    "/sport/cricket/world-cup/rss.xml" => "cgvp34rr2get",
    "/sport/cricket/teams/netherlands/rss.xml" => "cm03m1l7zzrt",
    "/sport/scotland/rss.xml" => "cxlx5km2kz4t",
    "/sport/scotland/shinty/rss.xml" => "c2q9x749znwt",
    "/sport/football/scottish/rss.xml" => "cn35kp0e8e9t",
    "/sport/football/womens/scottish/rss.xml" => "cky16k1901zt",
    "/sport/rugby-union/scottish/rss.xml" => "c5l3508wwz5t",
    "/sport/wales/rss.xml" => "ckedk23p1qvt",
    "/sport/football/welsh/rss.xml" => "c50nyjx1r5rt",
    "/sport/rugby-union/welsh/rss.xml" => "c6dry453pqzt",
    "/sport/northern-ireland/rss.xml" => "ckedk2l5el4t",
    "/sport/football/irish/rss.xml" => "czp1xkmzqj9t",
    "/sport/rugby-union/irish/rss.xml" => "cjw254lr9pjt",
    "/sport/northern-ireland/gaelic-games/rss.xml" => "c1nqel6z8pxt",
    "/sport/northern-ireland/motorbikes/rss.xml" => "ckedk2lr5x2t",
    "/sport/football/world-cup/rss.xml" => "cv8561l12rlt",
    "/sport/disability-sport/rss.xml" => "cdlxk1deyxvt",
    "/sport/winter-sports/rss.xml" => "c3yznj345zxt",
    "/sport/motorsport/rss.xml" => "c235xpq1jy5t",
    "/sport/american-football/rss.xml" => "cn35kp0enq4t",
    "/sport/basketball/rss.xml" => "cezyk0600qvt",
    "/sport/boxing/rss.xml" => "cq04k1z34yqt",
    "/sport/golf/rss.xml" => "c8jv1zyv193t",
    "/sport/snooker/rss.xml" => "c61kv8nk10nt",
    "/sport/netball/rss.xml" => "c0x65jdjyq1t",
    "/sport/mixed-martial-arts/rss.xml" => "c452mkql6qgt",
    "/sport/rugby-union/english/rss.xml" => "cxj4yk80wm5t",
    "/sport/sports-personality/rss.xml" => "c6dry45gpmjt",
    "/sport/football/european/rss.xml" => "cdlxk1deej1t",
    "/sport/football/european-championship/rss.xml" => "clx6k2y2n26t",
    "/sport/football/fa-cup/rss.xml" => "cn35kp0pn90t",
    "/sport/football/premier-league/rss.xml" => "clx6k2yqjm2t",
    "/sport/cricket/rss.xml" => "czp1xkm2jyyt",
    "/sport/cricket/video/rss.xml" => "cp0ezd3devwt",
    "/sport/cricket/womens/rss.xml" => "cpv3k82951pt",
    "/sport/cricket/counties/rss.xml" => "cpql9gyqj56t",
    "/sport/commonwealth-games/rss.xml" => "cpyd2m1m76dt",
    "/sport/olympics/rss.xml" => "clx6k2yrzkjt",
    "/sport/winter-olympics/rss.xml" => "cezyk0v3j11t",
    "/sport/athletics/rss.xml" => "cj59kpnp319t",
    "/sport/cycling/rss.xml" => "cpzrw9qgwelt",
    "/sport/horse-racing/rss.xml" => "cmnqk2vm53zt",
    "/sport/swimming/rss.xml" => "cdlxk1d3lp1t",
    "/sport/olympics/video/rss.xml" => "cz4x2xkr3ryt",
    "/sport/winter-olympics/video/rss.xml" => "cqg4k4q97r1t",
    "/sport/commonwealth-games/video/rss.xml" => "cyym8mkjpdrt",
    "/sport/football/world-cup/video/rss.xml" => "c0jmw9y9pgmt",
    "/sport/football/european-championship/video/rss.xml" => "cnw3g5n2w1qt",
    "/sport/football/fa-cup/video/rss.xml" => "cj0rkry944yt",
    "/sport/cricket/the-hundred/video/rss.xml" => "c44vmjgjp2et",
    "/sport/golf/video/rss.xml" => "cg84k4w9xd5t"
  }

  @impl Transformer
  def call(envelope) do
    envelope =
      Envelope.add(envelope, :request, %{
        path: "/fd/rss",
        path_params: %{
          "name" => "rss"
        },
        query_params: %{
          "topicId" => Map.get(@sport_feed_mapping, envelope.request.path),
          "uri" => String.replace(envelope.request.path, "/rss.xml", "")
        },
        raw_headers: %{
          "ctx-unwrapped" => "1"
        }
      })

    {:ok, envelope}
  end
end
