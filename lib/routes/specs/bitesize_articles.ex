defmodule Routes.Specs.BitesizeArticles do
  def specs("live") do
    %{
      owner: "bitesize-production@lists.forge.bbc.co.uk",
      platform: MorphRouter,
      language_from_cookie: true,
      pipeline: ["BitesizeArticlesPlatformDiscriminator", "HTTPredirect", "LambdaOriginAlias", "TrailingSlashRedirector", "CircuitBreaker"]
    }
  end

  def specs(_production_env) do
    %{
      owner: "bitesize-production@lists.forge.bbc.co.uk",
      platform: MorphRouter,
      language_from_cookie: true,
      pipeline: ["BitesizeArticlesPlatformDiscriminator", "HTTPredirect", "LambdaOriginAlias", "TrailingSlashRedirector", "DevelopmentRequests", "CircuitBreaker"]
    }
  end
end
