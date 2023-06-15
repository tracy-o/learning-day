defmodule Routes.Specs.WorldServiceTamilAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/tamil/sw.js", "/tamil/manifest.json"]
      }
    }
  end
end
