defmodule Routes.Specs.WorldServiceSwahiliAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/swahili/sw.js", "/swahili/manifest.json"]
      }
    }
  end
end
