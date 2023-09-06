defmodule Routes.Specs.PersonalisedAccount do
  def specification do
    %{
      specs: %{
        owner: "PersonalisedAccountOperations@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/Personalised+Account+-+For+You",
        platform: "Webcore",
        personalisation: "on",
        request_pipeline: ["PersonalisedAccountNonUkRedirect", "ComToUKRedirect", "PersonalisedAccountIsLoggedIn", "PersonalisedAccountU13Redirect", "PersonalisedAccountOffRedirect", "PersonalisedAccountProfilesRedirect", "PersonalisedAccountAccessGroup"]
      }
    }
  end
end
