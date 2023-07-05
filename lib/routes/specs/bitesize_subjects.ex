defmodule Routes.Specs.BitesizeSubjects do
  def specification do
    %{
      preflight_pipeline: ["BitesizeSubjectsPlatformSelector"],
      specs: [
        %{
          owner: "bitesize-production@lists.forge.bbc.co.uk",
          platform: "MorphRouter",
          language_from_cookie: true,
          request_pipeline: [
            "ComToUKRedirect",
            "BitesizeSubjectsPlatformDiscriminator",
            "LambdaOriginAlias",
            "Language"
          ],
          examples: []
        },
        %{
          owner: "bitesize-production@lists.forge.bbc.co.uk",
          platform: "Webcore",
          language_from_cookie: true,
          request_pipeline: ["ComToUKRedirect"],
          examples: ["/bitesize/subjects/z8tnvcw", "/bitesize/subjects/zbhy4wx"]
        }
      ]
    }
  end
end
