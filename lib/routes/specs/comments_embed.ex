defmodule Routes.Specs.CommentsEmbed do
  def specs do
    %{
      owner: "D&EHomeParticipationTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/Run+Book+for+Comments+on+WebCore",
      platform: MozartWeather,
      query_params_allowlist: ["embeddingPageUri", "embeddingPageTitle"]
    }
  end
end
