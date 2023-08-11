defmodule Routes.Specs.WorldServiceAmharicAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/amharic/sw.js", "/amharic/manifest.json"]
      }
    }
  end
end
