defmodule Routes.Specs.WorldServiceHausaAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/hausa/sw.js", "/hausa/manifest.json"]
      }
    }
  end
end
