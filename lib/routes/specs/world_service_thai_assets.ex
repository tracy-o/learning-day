defmodule Routes.Specs.WorldServiceThaiAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/thai/sw.js", "/thai/manifest.json"]
      }
    }
  end
end
