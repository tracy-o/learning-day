defmodule Routes.Specs.BitesizeWebcorePages do 
  def specs(production_env) do
    %{
      owner: "bitesize-production@lists.forge.bbc.co.uk",
      platform: MorphRouter,
      language_from_cookie: true,
      pipeline: pipeline(production_env)
    }
  end

  def pipeline("live") do 
    ["HTTPredirect", "TrailingSlashRedirector", "BitesizeWebcorePagesDiscriminator", "LambdaOriginAlias", "Language", "CircuitBreaker"]
  end
  def pipeline(_production_environment) do
   ["HTTPredirect", "TrailingSlashRedirector", "ComToUKRedirect", "BitesizeWebcorePagesDiscriminator", "LambdaOriginAlias", "DevelopmentRequests", "Language", "CircuitBreaker"]
  end
end
