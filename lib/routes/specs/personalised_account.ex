defmodule Routes.Specs.PersonalisedAccount do
  def specification do
    %{
      specs: %{
        owner: "PersonalisedAccountOperations@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCAccount/Personalised+Account+Runbook",
        platform: "Webcore",
        personalisation: "on",
        request_pipeline: ["PersonalisedAccountNonUkRedirect"]
      }
    }
  end
end
