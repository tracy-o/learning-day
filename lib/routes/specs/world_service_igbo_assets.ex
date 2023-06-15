defmodule Routes.Specs.WorldServiceIgboAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/igbo/sw.js", "/igbo/manifest.json"]
      }
    }
  end
end
