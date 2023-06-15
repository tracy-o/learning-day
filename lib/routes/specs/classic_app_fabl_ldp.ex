defmodule Routes.Specs.ClassicAppFablLdp do
  def specification do
    %{
      specs: %{
        owner: "D&EMorphCoreEngineering@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/WebCore/FABL+Run+Book",
        platform: "Fabl",
        request_pipeline: ["ClassicAppFablLdp"],
        response_pipeline: ["CacheDirective", "ClassicAppCacheControl", "ResponseHeaderGuardian", "PreCacheCompression", "Etag"],
        etag: true,
        examples: ["/content/ldp/de648736-7268-454c-a7b1-dbff416f2865"]
      }
    }
  end
end
