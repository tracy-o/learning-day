defmodule Routes.Specs.WorldServiceSomaliAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/somali/sw.js", "/somali/manifest.json"]
      }
    }
  end
end
