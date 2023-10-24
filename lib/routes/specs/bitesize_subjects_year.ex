defmodule Routes.Specs.BitesizeSubjectsYear do
  def specification do
    %{
      specs: %{
        email: "bitesize-production@lists.forge.bbc.co.uk",
        platform: "Webcore",
        language_from_cookie: true,
        request_pipeline: ["ComToUKRedirect"],
        examples: ["/bitesize/subjects/zjxhfg8/year/zjpqqp3"]
      }
    }
  end
end
