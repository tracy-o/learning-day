defmodule Routes.Specs.WorldServiceUkChina do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        headers_allowlist: ["cookie-ckps_chinese"],
        examples: ["/ukchina/simp", "/ukchina/trad", "/ukchina/trad.json", "/ukchina/trad.amp"]
      }
    }
  end
end
