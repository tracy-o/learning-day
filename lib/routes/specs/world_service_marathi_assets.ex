defmodule Routes.Specs.WorldServiceMarathiAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/marathi/sw.js", "/marathi/manifest.json"]
      }
    }
  end
end
