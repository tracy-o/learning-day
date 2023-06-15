defmodule Routes.Specs.WorldServiceArabicAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/arabic/sw.js", "/arabic/manifest.json"]
      }
    }
  end
end
