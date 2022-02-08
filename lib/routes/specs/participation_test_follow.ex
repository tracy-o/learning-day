defmodule Routes.Specs.ParticipationTestFollow do
  def specs do
    %{
      owner: "D&EHomeParticipationTeam@bbc.co.uk",
      platform: Webcore,
      query_params_allowlist: ["page"],
      personalisation: "test_only"
    }
  end
end
