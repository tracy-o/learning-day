defmodule Routes.Specs.SportData do
  def specs do
    %{
      platform: Fabl,
      response_pipeline: ["CacheDirective", "ClassicAppCacheControl", "ResponseHeaderGuardian", "PreCacheCompression", "ETag"],
      etag: true
    }
  end
end
