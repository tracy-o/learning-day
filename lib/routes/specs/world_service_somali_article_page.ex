defmodule Routes.Specs.WorldServiceSomaliArticlePage do
  def specs(production_env) do
    %{
      platform: Simorgh,
      pipeline: pipeline(production_env),
    }
  end

  defp pipeline("live"), do: ["WorldServiceRedirect"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
