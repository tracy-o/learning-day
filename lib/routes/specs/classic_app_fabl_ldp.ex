defmodule Routes.Specs.ClassicAppFablLdp do
  def specs do
    %{
      owner: "D&EMorphCoreEngineering@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/WebCore/FABL+Run+Book",
      platform: Fabl,
      request_pipeline: ["ClassicAppFablLdp"],
      response_pipeline: ["CacheDirective", "ClassicAppCacheControl", "ResponseHeaderGuardian", "PreCacheCompression", "Etag"],
      etag: true
    }
  end
end
