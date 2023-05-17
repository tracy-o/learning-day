defmodule Routes.Specs.BitesizeSubjects do
  def specification do
    %{
      specs: %{
        owner: "bitesize-production@lists.forge.bbc.co.uk",
        platform: "MorphRouter",
        language_from_cookie: true,
        request_pipeline: ["ComToUKRedirect", "BitesizeSubjectsPlatformDiscriminator", "LambdaOriginAlias", "Language"]
      }
    }
  end
end
