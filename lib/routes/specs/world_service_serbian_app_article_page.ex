defmodule Routes.Specs.WorldServiceSerbianAppArticlePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        headers_allowlist: ["cookie-ckps_serbian"],
        request_pipeline: ["WorldServiceRedirect"]
      }
    }
  end
end
