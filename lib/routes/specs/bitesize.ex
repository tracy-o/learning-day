defmodule Routes.Specs.Bitesize do
  def specs do
    %{
      owner: "bitesize-production@lists.forge.bbc.co.uk",
      platform: Webcore,
      pipeline: ["ComToUKRedirect"],
      language_from_cookie: true
    }
  end
end
