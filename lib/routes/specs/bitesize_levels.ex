defmodule Routes.Specs.BitesizeLevels do
  def specification do
    %{
      specs: %{
        owner: "bitesize-production@lists.forge.bbc.co.uk",
        platform: "MorphRouter",
        language_from_cookie: true,
        request_pipeline: ["ComToUKRedirect", "BitesizeLevelsPlatformDiscriminator", "LambdaOriginAlias", "Language"]
      }
    }
  end
end
