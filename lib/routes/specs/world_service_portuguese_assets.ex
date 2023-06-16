defmodule Routes.Specs.WorldServicePortugueseAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/portuguese/sw.js", "/portuguese/manifest.json"]
      }
    }
  end
end
