defmodule Routes.Specs.MyTopicsPage do
  def specs(env) do
    %{
      owner: "newsappsabl@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/pages/viewpage.action?pageId=342561568",
      platform: "Fabl",
      personalisation: "on",
      fallback_write_sample: 0,
      caching_enabled: false,
      request_pipeline: request_pipeline(env),
      response_pipeline: ["CacheDirective", "ClassicAppCacheControl", "ResponseHeaderGuardian", "PreCacheCompression", "Etag"],
      etag: true
    }
  end

  defp request_pipeline("live"), do: []

  defp request_pipeline(_env), do: ["AppPersonalisationHalter"]
end
