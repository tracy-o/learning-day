defmodule Routes.Specs.WorldServiceSerbianArticlePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        headers_allowlist: ["cookie-ckps_serbian"],
        request_pipeline: ["WorldServiceRedirect"],
        examples: []
      }
    }
  end
end
