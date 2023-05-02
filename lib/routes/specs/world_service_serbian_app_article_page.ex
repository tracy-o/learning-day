defmodule Routes.Specs.WorldServiceSerbianAppArticlePage do
  def specs do
    %{
      platform: "Simorgh",
      headers_allowlist: ["cookie-ckps_serbian"],
      request_pipeline: ["WorldServiceRedirect"]
    }
  end
end
