defmodule Routes.Specs.WorldServiceSerbian do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        headers_allowlist: ["cookie-ckps_serbian"],
        examples: ["/serbian/lat", "/serbian/lat.json", "/serbian/lat.amp"]
      }
    }
  end
end
