defmodule Routes.Specs.WorldServiceTigrinyaAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/tigrinya/sw.js", "/tigrinya/manifest.json"]
      }
    }
  end
end
