defmodule Routes.Specs.BitesizeGuides do
  def specs do
    %{
      owner: "bitesize-production@lists.forge.bbc.co.uk",
      platform: MorphRouter,
      language_from_cookie: true,
      personalisation: "on",
      request_pipeline: ["ComToUKRedirect", "BitesizeGuidesPlatformDiscriminator", "LambdaOriginAlias", "Language"]
    }
  end
end
