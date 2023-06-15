defmodule Routes.Specs.WorldServiceGujaratiAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/gujarati/sw.js", "/gujarati/manifest.json"]
      }
    }
  end
end
