defmodule Belfrage.RequestTransformers.NewsAppsHardcodedResponse do
  use Belfrage.Transformer
  alias Belfrage.NewsApps

  @dial Application.get_env(:belfrage, :dial)

  @impl true
  def call(rest, struct) do
    if dial_active?() do
      {
        :stop_pipeline,
        Struct.add(struct, :response, %{
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
      then_do(rest, struct)
    end
  end

  defp dial_active? do
    @dial.state(:news_apps_hardcoded_response) == "enabled"
  end
end
