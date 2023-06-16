defmodule Routes.Specs.AblDataPreview do
  def specification do
    %{
      specs: %{
        owner: "#data-systems",
        runbook: "https://confluence.dev.bbc.co.uk/display/TREVOR/Trevor+V3+%28News+Apps+Data+Service%29+Runbook",
        platform: "Fabl",
        request_pipeline: ["NewsAppsHardcodedResponse"],
        response_pipeline: ["CacheDirective", "ClassicAppCacheControl", "ResponseHeaderGuardian", "PreCacheCompression", "Etag"],
        etag: true,
        examples: []
      }
    }
  end
end
