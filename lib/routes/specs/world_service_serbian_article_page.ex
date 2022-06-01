defmodule Routes.Specs.WorldServiceSerbianArticlePage do
  def specs(production_env) do
    %{
      platform: Simorgh,
      pipeline: pipeline(production_env),
      headers_allowlist: ["cookie-ckps_serbian"]
    }
  end
end
