defmodule Routes.Specs.WorldServiceKyrgyzAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/kyrgyz/sw.js", "/kyrgyz/manifest.json"]
      }
    }
  end
end
