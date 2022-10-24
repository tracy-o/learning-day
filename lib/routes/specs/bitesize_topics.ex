
defmodule Routes.Specs.BitesizeTopics do
  def specs(production_env) do
    %{
      owner: "bitesize-production@lists.forge.bbc.co.uk",
      platform: MorphRouter,
      language_from_cookie: true,
      request_pipeline: pipeline(production_env)
    }
  end

  def pipeline("live") do
    ["HTTPredirect", "ComToUKRedirect", "BitesizeTopicsPlatformDiscriminator", "LambdaOriginAlias", "Language", "CircuitBreaker"]
  end
  def pipeline(_production_environment) do
   ["HTTPredirect", "ComToUKRedirect", "BitesizeTopicsPlatformDiscriminator", "LambdaOriginAlias", "DevelopmentRequests", "Language", "CircuitBreaker"]
  end
end
