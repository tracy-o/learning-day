defmodule Routes.Specs.BitesizeLevels do
  def specs(production_env) do
    %{
      owner: "bitesize-production@lists.forge.bbc.co.uk",
      platform: MorphRouter,
      language_from_cookie: true,
      request_pipeline: pipeline(production_env)
    }
  end

  def pipeline("live") do
    ["ComToUKRedirect", "BitesizeLevelsPlatformDiscriminator", "LambdaOriginAlias", "Language", "CircuitBreaker"]
  end
  def pipeline(_production_environment) do
   ["ComToUKRedirect", "BitesizeLevelsPlatformDiscriminator", "LambdaOriginAlias", "DevelopmentRequests", "Language", "CircuitBreaker"]
  end
end
