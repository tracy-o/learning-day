defmodule Routes.Specs.WorldServiceJapaneseAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/japanese/sw.js", "/japanese/manifest.json"]
      }
    }
  end
end
