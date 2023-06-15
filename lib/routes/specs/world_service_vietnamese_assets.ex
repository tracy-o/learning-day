defmodule Routes.Specs.WorldServiceVietnameseAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/vietnamese/sw.js", "/vietnamese/manifest.json"]
      }
    }
  end
end
