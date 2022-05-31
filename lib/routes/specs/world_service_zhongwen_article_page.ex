defmodule Routes.Specs.WorldServiceZhongwenArticlePage do
  def specs(production_env) do
    %{
      platform: Simorgh,
      pipeline: pipeline(production_env),
      headers_allowlist: ["cookie-ckps_chinese"]
    }
  end

  defp pipeline("live"), do: ["WorldServiceRedirect"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
