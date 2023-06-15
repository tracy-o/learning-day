defmodule Routes.Specs.BitesizeArticles do
  def specification do
    %{
      preflight_pipeline: ["BitesizeArticlesPlatformSelector"],
      specs: [
        %{
          owner: "bitesize-production@lists.forge.bbc.co.uk",
          platform: "MorphRouter",
          language_from_cookie: true,
          request_pipeline: ["ComToUKRedirect", "Language"],
          query_params_allowlist: ["course", "topicJourney"],
          examples: []
        },
        %{
          owner: "bitesize-production@lists.forge.bbc.co.uk",
          platform: "Webcore",
          language_from_cookie: true,
          personalisation: "on",
          request_pipeline: ["ComToUKRedirect"],
          query_params_allowlist: ["course", "topicJourney"],
          examples: ["/bitesize/articles/zj8yydm"]
        }
      ]
    }
  end
end
