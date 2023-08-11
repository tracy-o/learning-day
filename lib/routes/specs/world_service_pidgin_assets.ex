defmodule Routes.Specs.WorldServicePidginAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/pidgin/sw.js", "/pidgin/manifest.json"]
      }
    }
  end
end
