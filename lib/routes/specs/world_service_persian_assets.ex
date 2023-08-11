defmodule Routes.Specs.WorldServicePersianAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/persian/sw.js", "/persian/manifest.json"]
      }
    }
  end
end
