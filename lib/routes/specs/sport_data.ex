defmodule Routes.Specs.SportData do
  def specification do
    %{
      specs: %{
        platform: "Fabl",
        response_pipeline: ["CacheDirective", "ClassicAppCacheControl", "ResponseHeaderGuardian", "PreCacheCompression", "Etag"],
        etag: true
      }
    }
  end
end
