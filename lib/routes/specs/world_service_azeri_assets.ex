defmodule Routes.Specs.WorldServiceAzeriAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/azeri/sw.js", "/azeri/manifest.json"]
      }
    }
  end
end
