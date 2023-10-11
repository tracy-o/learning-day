defmodule Routes.Specs.BitesizePrimary do
  def specification do
    %{
      specs: %{
        owner: "bitesize-production@lists.forge.bbc.co.uk",
        platform: "Webcore",
        request_pipeline: ["ComToUKRedirect"],
        language_from_cookie: true,
        query_params_allowlist: [],
        examples: ["/bitesize/primary"]
      }
    }
  end
end
