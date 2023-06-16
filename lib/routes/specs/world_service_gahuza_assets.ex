defmodule Routes.Specs.WorldServiceGahuzaAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/gahuza/sw.js", "/gahuza/manifest.json"]
      }
    }
  end
end
