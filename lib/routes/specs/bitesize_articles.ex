defmodule Routes.Specs.BitesizeArticles do
  def specs("live") do
    %{
      owner: "bitesize-production@lists.forge.bbc.co.uk",
      platform: MorphRouter,
      pipeline: ["BitesizeArticlesPlatformDiscriminator", "HTTPredirect", "TrailingSlashRedirector", "CircuitBreaker"]
    }
  end

  def specs(_production_env) do
    %{
      owner: "bitesize-production@lists.forge.bbc.co.uk",
      platform: MorphRouter,
      pipeline: ["BitesizeArticlesPlatformDiscriminator", "HTTPredirect", "TrailingSlashRedirector", "DevelopmentRequests", "CircuitBreaker"]
    }
  end
end
