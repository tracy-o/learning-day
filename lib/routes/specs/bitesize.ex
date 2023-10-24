defmodule Routes.Specs.Bitesize do
  def specification do
    %{
      specs: %{
        email: "bitesize-production@lists.forge.bbc.co.uk",
        platform: "Webcore",
        request_pipeline: ["ComToUKRedirect"],
        language_from_cookie: true,
        query_params_allowlist: ["course"],
        examples: ["/bitesize/subjects"]
      }
    }
  end
end
