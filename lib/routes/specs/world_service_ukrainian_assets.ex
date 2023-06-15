defmodule Routes.Specs.WorldServiceUkrainianAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/ukrainian/sw.js", "/ukrainian/manifest.json"]
      }
    }
  end
end
