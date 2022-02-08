defmodule Routes.Specs.NewsVideosEmbed do
  def specs do
    %{
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      platform: MozartNews,
      query_params_allowlist: ["amp"]
    }
  end

end
