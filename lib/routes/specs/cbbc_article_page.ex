defmodule Routes.Specs.CBBCArticlePage do
  def specification do
    %{
      specs: %{
        owner: "childrensfutureweb@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/NEWSCPSSTOR/News+CPS+Stories+Run+Book",
        platform: "Webcore",
        request_pipeline: ["ComToUKRedirect"],
        examples: []
      }
    }
  end
end
