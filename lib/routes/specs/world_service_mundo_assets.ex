defmodule Routes.Specs.WorldServiceMundoAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/mundo/sw.js", "/mundo/manifest.json"]
      }
    }
  end
end
