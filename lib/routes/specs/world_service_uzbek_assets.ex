defmodule Routes.Specs.WorldServiceUzbekAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/uzbek/sw.js", "/uzbek/manifest.json"]
      }
    }
  end
end
