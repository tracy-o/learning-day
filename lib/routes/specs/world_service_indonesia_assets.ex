defmodule Routes.Specs.WorldServiceIndonesiaAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/indonesia/sw.js", "/indonesia/manifest.json"]
      }
    }
  end
end
