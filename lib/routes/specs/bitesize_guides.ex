defmodule Routes.Specs.BitesizeGuides do
  def specs do
    %{
      owner: "bitesize-production@lists.forge.bbc.co.uk",
      platform: MorphRouter,
      language_from_cookie: true,
      personalisation: "test_only",
      request_pipeline: ["ComToUKRedirect", "Personalisation", "BitesizeGuidesPlatformDiscriminator", "LambdaOriginAlias", "Language"]
    }
  end
end
