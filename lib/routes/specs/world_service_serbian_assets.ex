defmodule Routes.Specs.WorldServiceSerbianAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/serbian/sw.js", "/serbian/manifest.json"]
      }
    }
  end
end
