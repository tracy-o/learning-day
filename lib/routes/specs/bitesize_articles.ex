defmodule Routes.Specs.BitesizeArticles do
  def specs(production_env) do
    %{
      owner: "bitesize-production@lists.forge.bbc.co.uk",
      platform: MorphRouter,
      language_from_cookie: true,
      request_pipeline: pipeline(production_env),
      query_params_allowlist: ["course", "topicJourney"]
    }
  end

  def pipeline("live"), do: ["ComToUKRedirect", "BitesizeArticlesPlatformDiscriminator", "LambdaOriginAlias", "Language"]
  def pipeline(_production_env), do: pipeline("live")
end
