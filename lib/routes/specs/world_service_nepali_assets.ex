defmodule Routes.Specs.WorldServiceNepaliAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/nepali/sw.js", "/nepali/manifest.json"]
      }
    }
  end
end
