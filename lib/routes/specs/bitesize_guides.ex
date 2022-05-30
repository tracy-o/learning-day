defmodule Routes.Specs.BitesizeGuides do
  def specs(production_env) do
    %{
      owner: "bitesize-production@lists.forge.bbc.co.uk",
      platform: MorphRouter,
      language_from_cookie: true,
      pipeline: pipeline(production_env)
    }
  end

  def pipeline("live") do
    ["HTTPredirect", "TrailingSlashRedirector", "BitesizeGuidesPlatformDiscriminator", "LambdaOriginAlias", "Language", "CircuitBreaker"]
  end

  def pipeline(_production_env) do
    ["HTTPredirect", "TrailingSlashRedirector", "ComToUKRedirect", "BitesizeGuidesPlatformDiscriminator", "LambdaOriginAlias", "DevelopmentRequests", "Language", "CircuitBreaker"]
  end
end
