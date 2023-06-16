defmodule Routes.Specs.WorldServicePunjabiAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/punjabi/sw.js", "/punjabi/manifest.json"]
      }
    }
  end
end
