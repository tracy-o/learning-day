defmodule Belfrage.NewsApps.Failover do
  use GenServer

  alias Belfrage.Utils

  def start_link(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  @impl true
  def init(_state) do
    state = generate_hardcoded_response()

    schedule_work()

    {:ok, state}
  end

  def body() do
    GenServer.call(__MODULE__, :body, 1000)
  end

  def update() do
    GenServer.call(__MODULE__, :update, 1000)
  end

  @impl true
  def handle_call(:body, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call(:update, _from, _state) do
    state = generate_hardcoded_response()
    {:reply, state, state}
  end

  @impl true
  def handle_info(:scheduled_update, state) do
    schedule_work()

    {:noreply, state}
  end

  defp generate_hardcoded_response do
    uncompressed_body() |> :zlib.gzip()
  end

  defp schedule_work do
    Process.send_after(self(), :scheduled_update, :timer.hours(1))
  end

  defp uncompressed_body do
    epoch =
      Belfrage.Utils.Current.date_time()
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
               "subtitle": "Please visit our website for the latest news.",
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
