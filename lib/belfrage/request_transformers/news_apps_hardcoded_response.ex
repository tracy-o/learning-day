defmodule Belfrage.RequestTransformers.NewsAppsHardcodedResponse do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.NewsApps

  @dial Application.compile_env(:belfrage, :dial)

  @impl Transformer
  def call(envelope) do
    if dial_active?() do
      {
        :stop,
        Envelope.add(envelope, :response, %{
          http_status: 200,
          headers: %{
            "content-type" => "application/json; charset=utf-8",
            "cache-control" => "public, max-age=5",
            "content-encoding" => "gzip"
          },
          body: NewsApps.Failover.body()
        })
      }
    else
      {:ok, envelope}
    end
  end

  defp dial_active? do
    @dial.get_dial(:news_apps_hardcoded_response)
  end
end
