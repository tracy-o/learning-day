defmodule Routes.Specs.AblData do
  def specs do
    %{
      owner: "#data-systems",
      runbook: "https://confluence.dev.bbc.co.uk/display/TREVOR/Trevor+V3+%28News+Apps+Data+Service%29+Runbook",
      platform: Fabl,
			response_pipeline: ["CacheDirective", "ClassicAppCacheControl", "ResponseHeaderGuardian", "PreCacheCompression", "ETag"],
      etag: true
    }
  end
end
