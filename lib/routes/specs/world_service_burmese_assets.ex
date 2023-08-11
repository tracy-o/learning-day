defmodule Routes.Specs.WorldServiceBurmeseAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/burmese/sw.js", "/burmese/manifest.json"]
      }
    }
  end
end
