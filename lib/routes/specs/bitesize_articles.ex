defmodule Routes.Specs.BitesizeArticles do
  def specs do
    %{
      owner: "bitesize-production@lists.forge.bbc.co.uk",
      platform: MorphRouter,
      language_from_cookie: true,
      personalisation: "on"
      request_pipeline: ["ComToUKRedirect", "Personalisation", "BitesizeArticlesPlatformDiscriminator", "LambdaOriginAlias", "Language"],
      query_params_allowlist: ["course", "topicJourney"]
    }
  end
end
