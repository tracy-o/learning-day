defmodule Routes.Specs.MySession do
  def specs do
    %{
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      platform: OriginSimulator,
      origin: :stubbed_session_origin,
      pipeline: ["UserSession"],
      headers_allowlist: ["cookie"]
    }
  end
end
