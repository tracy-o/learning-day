defmodule Routes.Specs.WorldServiceKoreanAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/korean/sw.js", "/korean/manifest.json"]
      }
    }
  end
end
