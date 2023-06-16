defmodule Routes.Specs.WorldServiceUkChinaAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/ukchina/sw.js", "/ukchina/manifest.json"]
      }
    }
  end
end
