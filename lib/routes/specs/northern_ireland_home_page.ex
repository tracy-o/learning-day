defmodule Routes.Specs.NorthernIrelandHomePage do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/Homepage%20&%20Nations%20-%20WebCore%20-%20Runbook",
        platform: "Webcore",
        personalisation: "on",
        examples: ["/northernireland"]
      }
    }
  end
end
