defmodule Routes.Specs.BitesizeArticles do
  def specs("live") do
    %{
      owner: "bitesize-production@lists.forge.bbc.co.uk",
      platform: MorphRouter,
      language_from_cookie: true,
      pipeline: ["HTTPredirect", "ComToUKRedirect", "BitesizeArticlesPlatformDiscriminator", "LambdaOriginAlias", "Language", "CircuitBreaker"],
      query_params_allowlist: ["course"]
    }
  end

  def specs(_production_env) do
    %{
      owner: "bitesize-production@lists.forge.bbc.co.uk",
      platform: MorphRouter,
      language_from_cookie: true,
      pipeline: ["HTTPredirect", "ComToUKRedirect", "BitesizeArticlesPlatformDiscriminator", "LambdaOriginAlias", "DevelopmentRequests", "Language", "CircuitBreaker"],
      query_params_allowlist: ["course"]
    }
  end
end
