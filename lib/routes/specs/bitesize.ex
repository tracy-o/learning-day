defmodule Routes.Specs.Bitesize do
  def specs do
    %{
      owner: "bitesize-production@lists.forge.bbc.co.uk",
      platform: Webcore,
      request_pipeline: ["ComToUKRedirect"],
      language_from_cookie: true,
      query_params_allowlist: ["course"]
    }
  end
end
