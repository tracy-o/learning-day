defmodule Routes.Specs.WorldServiceZhongwen do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        headers_allowlist: ["cookie-ckps_chinese"],
        examples: ["/zhongwen/simp", "/zhongwen/trad", "/zhongwen/trad.json", "/zhongwen/trad.amp"]
      }
    }
  end
end
