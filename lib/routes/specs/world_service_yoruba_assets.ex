defmodule Routes.Specs.WorldServiceYorubaAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/yoruba/sw.js", "/yoruba/manifest.json"]
      }
    }
  end
end
