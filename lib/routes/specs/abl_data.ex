defmodule Routes.Specs.AblData do
  def specification do
    %{
      preflight_pipeline: ["AblDataPartitionSelector"],
      specs: %{
        slack_channel: "#data-systems",
        runbook: "https://confluence.dev.bbc.co.uk/display/TREVOR/Trevor+V3+%28News+Apps+Data+Service%29+Runbook",
        platform: "Fabl",
        circuit_breaker_error_threshold: 2_000,
        request_pipeline: ["NewsAppsHardcodedResponse"],
        response_pipeline: [
          "CacheDirective",
          "ClassicAppCacheControl",
          "ResponseHeaderGuardian",
          "PreCacheCompression",
          "Etag"
        ],
        etag: true,
        examples: ["/fd/abl?clientName=Hindi&clientVersion=pre-4&page=india-63495511&release=public-alpha&service=hindi&type=asset"]
      }
    }
  end
end
