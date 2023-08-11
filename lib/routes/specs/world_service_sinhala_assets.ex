defmodule Routes.Specs.WorldServiceSinhalaAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/sinhala/sw.js", "/sinhala/manifest.json"]
      }
    }
  end
end
