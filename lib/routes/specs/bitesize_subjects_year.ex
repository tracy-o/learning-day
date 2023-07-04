defmodule Routes.Specs.BitesizeSubjectsYear do
  def specification do
    %{
      specs: %{
        owner: "bitesize-production@lists.forge.bbc.co.uk",
        platform: "MorphRouter",
        language_from_cookie: true,
        request_pipeline: ["ComToUKRedirect", "BitesizeSubjectsPlatformDiscriminator", "LambdaOriginAlias", "Language"],
        examples: ["/bitesize/subjects/zjxhfg8/year/zjpqqp3"]
      }
    }
  end
end