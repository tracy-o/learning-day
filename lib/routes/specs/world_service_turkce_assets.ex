defmodule Routes.Specs.WorldServiceTurkceAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/turkce/sw.js", "/turkce/manifest.json"]
      }
    }
  end
end
