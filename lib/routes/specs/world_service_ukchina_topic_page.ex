defmodule Routes.Specs.WorldServiceUkchinaTopicPage do
  def specs(production_env) do
    %{
      platform: Simorgh,
      pipeline: pipeline(production_env),
      query_params_allowlist: ["page"],
      headers_allowlist: ["cookie-ckps_chinese"]
    }
  end

  defp pipeline("live"), do: ["WorldServiceTopicsGuid", "WorldServiceRedirect"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
