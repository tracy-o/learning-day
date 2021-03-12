defmodule Routes.Specs.NewsHomePage do
  def specs(production_env) do
    %{
      owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
      platform: MozartNews,
      pipeline: pipeline(production_env)
    }
  end

  defp pipeline("live"), do: ["HTTPredirect", "TrailingSlashRedirector", "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
