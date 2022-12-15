defmodule Routes.Specs.MyTopicsPage do
  def specs(env) do
    %{
      owner: "DandESportApp@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/sportws4/My+Topics+Run+Book",
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
