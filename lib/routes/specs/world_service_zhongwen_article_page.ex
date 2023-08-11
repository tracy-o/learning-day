defmodule Routes.Specs.WorldServiceZhongwenArticlePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        headers_allowlist: ["cookie-ckps_chinese"],
        examples: []
      }
    }
  end
end
