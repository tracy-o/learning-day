defmodule Routes.Specs.WorldServiceUrduAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/urdu/sw.js", "/urdu/manifest.json"]
      }
    }
  end
end
