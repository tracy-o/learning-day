defmodule Routes.Specs.BitesizeGuides do
  def specs("live") do
    %{
      owner: "bitesize-production@lists.forge.bbc.co.uk",
      platform: MorphRouter,
      language_from_cookie: true,
      pipeline: ["HTTPredirect", "TrailingSlashRedirector", "BitesizeGuidesPlatformDiscriminator", "LambdaOriginAlias", "Language", "CircuitBreaker"]
    }
  end

  def specs(_production_env) do
    %{
      owner: "bitesize-production@lists.forge.bbc.co.uk",
      platform: MorphRouter,
      language_from_cookie: true,
      pipeline: ["HTTPredirect", "TrailingSlashRedirector", "ComToUKRedirect", "BitesizeGuidesPlatformDiscriminator", "LambdaOriginAlias", "DevelopmentRequests", "Language", "CircuitBreaker"]
    }
  end
end
