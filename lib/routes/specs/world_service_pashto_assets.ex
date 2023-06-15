defmodule Routes.Specs.WorldServicePashtoAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/pashto/sw.js", "/pashto/manifest.json"]
      }
    }
  end
end
