defmodule Routes.Specs.WorldServiceBengaliAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/bengali/sw.js", "/bengali/manifest.json"]
      }
    }
  end
end
