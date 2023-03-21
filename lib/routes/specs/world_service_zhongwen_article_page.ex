defmodule Routes.Specs.WorldServiceZhongwenArticlePage do
  def specs do
    %{
      platform: "Simorgh",
      request_pipeline: ["WorldServiceRedirect"],
      headers_allowlist: ["cookie-ckps_chinese"]
    }
  end
end
