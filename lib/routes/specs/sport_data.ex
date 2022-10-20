defmodule Routes.Specs.SportData do
  def specs do
    %{
      platform: Fabl,
      response_pipeline: ["CacheDirective", "ClassicAppCacheControl", "ResponseHeaderGuardian", "PreCacheCompression", "Etag"],
      etag: true
    }
  end
end
