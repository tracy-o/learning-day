defmodule Routes.Specs.BitesizeTopics do
  def specs do
    [
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
  end

  def pre_flight_pipeline do
    ["BitesizeTopicsPlatformSelector"]
  end
end
