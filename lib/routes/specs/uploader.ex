defmodule Routes.Specs.Uploader do
  def specification do
    %{
      specs: %{
        email: "D&EHomeParticipationTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/pages/viewpage.action?pageId=300173395",
        platform: "Webcore",
        personalisation: "on",
        request_pipeline: ["ComToUKRedirect"],
        examples: ["/send/u39697902"]
      }
    }
  end
end
