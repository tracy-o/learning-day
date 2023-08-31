defmodule Belfrage.RequestTransformers.SportTopicRssFeedsMapper do
  @moduledoc """
  Does the mapping between path and topicId.
  Alters the Platform for a subset of Sport RSS feeds that need to be served by FABL.
  """
  use Belfrage.Behaviours.Transformer

  @sport_feed_mapping %{
    "/sport/rss.xml" => "c22ymglr3x3t",
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
    "/sport/football/premier-league/rss.xml" => "clx6k2yqjm2t"
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
