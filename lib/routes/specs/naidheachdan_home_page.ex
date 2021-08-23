defmodule Routes.Specs.NaidheachdanHomePage do
  def specs(production_env) do
    %{
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      platform: MozartNews,
      pipeline: pipeline(production_env)
    }
  end

  defp pipeline(_production_env), do: ["NaidheachdanObitRedirect"]
end
