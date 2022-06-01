defmodule Routes.Specs.WorldServiceArabicTopicPage do
  def specs(production_env) do
    %{
      platform: Simorgh,
      pipeline: pipeline(production_env),
      query_params_allowlist: ["page"]
    }
  end

  defp pipeline("live"), do: ["WorldServiceTopicsGuid"]
end
