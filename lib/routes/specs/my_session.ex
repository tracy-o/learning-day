defmodule Routes.Specs.MySession do
  def specification do
    %{
      specs: %{
        email: "DENewsFrameworksTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
        platform: "OriginSimulator",
        origin: :stubbed_session_origin,
        request_pipeline: ["SessionState", "PersonalisationGuardian"],
        personalisation: "test_only"
      }
    }
  end
end
