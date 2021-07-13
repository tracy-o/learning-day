defmodule Routes.Specs.FullStackTestA do
  def specs(production_env) do
    %{
      owner: "fabl@onebbc.onmicrosoft.com",
      platform: Webcore,
      pipeline: pipeline(production_env),
      personalisation: "test_only"
    }
  end

  defp pipeline("live") do
    ["HTTPredirect", "TrailingSlashRedirector", "Personalisation", "LambdaOriginAlias", "CircuitBreaker", "Language"]
  end

  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
