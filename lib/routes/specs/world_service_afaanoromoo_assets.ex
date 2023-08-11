defmodule Routes.Specs.WorldServiceAfaanoromooAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/afaanoromoo/sw.js", "/afaanoromoo/manifest.json"]
      }
    }
  end
end
