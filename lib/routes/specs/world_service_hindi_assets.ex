defmodule Routes.Specs.WorldServiceHindiAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/hindi/sw.js", "/hindi/manifest.json"]
      }
    }
  end
end
