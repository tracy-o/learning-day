defmodule Belfrage.RequestTransformers.NewsAppsHardcodedResponse do
  use Belfrage.Transformer
  alias Belfrage.Utils

  @dial Application.get_env(:belfrage, :dial)

  @impl true
  def call(rest, struct) do
    if dial_active?() do
      {
        :stop_pipeline,
        Struct.add(struct, :response, %{
          http_status: 200,
          headers: %{"content-type" => "application/json", "cache-control" => "public, max-age=5"},
          body: hardcoded_body()
        })
      }
    else
      then_do(rest, struct)
    end
  end

  defp dial_active? do
    @dial.state(:news_apps_hardcoded_response) == "enabled"
  end

  defp hardcoded_body do
    epoch =
      DateTime.utc_now()
      |> Utils.DateTime.beginning_of_the_hour()
      |> DateTime.to_unix(:millisecond)

    ~s({"data": {
           "metadata": {
             "name": "Home",
             "allowAdvertising": true,
             "lastUpdated": #{epoch},
             "shareUrl": "https://www.bbc.co.uk/news/front_page"
           },
           "items": [
             {
               "type": "CallToActionBanner",
               "title": "The BBC News app is unavailable at the moment.",
               "subtitle": "Please visit our website for the latest updates.",
               "buttons": [
                 {
                   "title": "bbc.co.uk/news",
                   "link": {
                     "trackers": [],
                     "destinations": [
                       {
                         "sourceFormat": "HTML",
                         "url": "https://www.bbc.co.uk/news",
                         "id": "https://www.bbc.co.uk/news",
                         "presentation": {
                           "type": "WEB",
                           "contentSource": "EXTERNAL"
                         }
                       }
                     ]
                   }
                 }
               ]
             },
             {
               "type": "Copyright",
               "lastUpdated": #{epoch}
             }
           ],
           "trackers": []
        },
        "contentType": "application/json; charset=utf-8"}
    )
  end
end
