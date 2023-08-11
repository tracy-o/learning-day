defmodule Routes.Specs.WorldServiceRussianAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/russian/sw.js", "/russian/manifest.json"]
      }
    }
  end
end
