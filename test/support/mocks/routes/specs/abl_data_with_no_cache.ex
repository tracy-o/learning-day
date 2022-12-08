defmodule Routes.Specs.AblDataWithNoCache do
  def specs do
    %{
      platform: Fabl,
      request_pipeline: ["NewsAppsHardcodedResponse"],
      response_pipeline: [
        "CacheDirective",
        "ClassicAppCacheControl",
        "ResponseHeaderGuardian",
        "PreCacheCompression",
        "Etag"
      ],
      etag: true,
      caching_enabled: false
    }
  end
end
