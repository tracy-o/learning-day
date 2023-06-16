defmodule Routes.Specs.BitesizeTopics do
  def specification do
    %{
      preflight_pipeline: ["BitesizeTopicsPlatformSelector"],
      specs: [
        %{
          owner: "bitesize-production@lists.forge.bbc.co.uk",
          platform: "MorphRouter",
          language_from_cookie: true,
          request_pipeline: ["ComToUKRedirect", "Language"]
        },
        %{
          owner: "bitesize-production@lists.forge.bbc.co.uk",
          platform: "Webcore",
          language_from_cookie: true,
          request_pipeline: ["ComToUKRedirect"]
        }
      ]
    }
  end
end
