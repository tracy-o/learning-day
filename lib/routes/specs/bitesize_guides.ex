defmodule Routes.Specs.BitesizeGuides do
  def specification do
    %{
      preflight_pipeline: ["BitesizeGuidesPlatformSelector"],
      specs: [
        %{
          owner: "bitesize-production@lists.forge.bbc.co.uk",
          platform: "MorphRouter",
          language_from_cookie: true,
          request_pipeline: ["ComToUKRedirect", "Language"],
          examples: []
        },
        %{
          owner: "bitesize-production@lists.forge.bbc.co.uk",
          platform: "Webcore",
          language_from_cookie: true,
          personalisation: "on",
          request_pipeline: ["ComToUKRedirect"],
          examples: ["/bitesize/guides/z9ppv4j/revision/1"]
        }
      ]
    }
  end
end
