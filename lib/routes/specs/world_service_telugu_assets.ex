defmodule Routes.Specs.WorldServiceTeluguAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/telugu/sw.js", "/telugu/manifest.json"]
      }
    }
  end
end
