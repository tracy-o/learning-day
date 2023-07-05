defmodule Routes.Specs.MySession do
  def specification do
    %{
      specs: %{
        owner: "DENewsFrameworksTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
        platform: "OriginSimulator",
        origin: :stubbed_session_origin,
        request_pipeline: ["PersonalisationGuardian"],
        personalisation: "test_only"
      }
    }
  end
end
