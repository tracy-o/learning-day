defmodule Routes.Specs.WorldServiceZhongwenAssets do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/zhongwen/sw.js", "/zhongwen/manifest.json"]
      }
    }
  end
end
