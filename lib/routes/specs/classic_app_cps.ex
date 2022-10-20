defmodule Routes.Specs.ClassicAppCps do
  def specs do
    %{
      owner: "#data-systems",
      runbook: "https://confluence.dev.bbc.co.uk/display/TREVOR/Trevor+V3+%28News+Apps+Data+Service%29+Runbook",
      platform: ClassicApps,
      query_params_allowlist: ["subjectId", "language", "createdBy"],
      response_pipeline: ["CacheDirective", "ClassicAppCacheControl", "ResponseHeaderGuardian", "PreCacheCompression", "Etag"],
      etag: true
    }
  end
end
