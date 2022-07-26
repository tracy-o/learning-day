defmodule Routes.Specs.ClassicAppFablLdp do
  def specs(env) do
    %{
      owner: "D&EMorphCoreEngineering@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/WebCore/FABL+Run+Book",
      platform: Fabl,
      pipeline: pipeline(env),
      etag: true
    }
  end

  defp pipeline("live") do
    ["HTTPredirect", "TrailingSlashRedirector", "ClassicAppFablLdp", "CircuitBreaker"]
  end

  defp pipeline(_production_env) do
    pipeline("live") ++ ["Personalisation", "DevelopmentRequests"]
  end
end
