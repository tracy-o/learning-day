defmodule Routes.Specs.WorldServiceMvtPoc do
  def specs(production_env) do
    %{
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      platform: Simorgh,
      pipeline: pipeline(production_env),
      headers_allowlist: mvt_headers(),
      caching_enabled: false
    }
  end

  defp mvt_headers do
    1..20 |> Enum.map(fn i -> "bbc-mvt-#{i}" end)
  end

  defp pipeline("live"),
    do: ["HTTPredirect", "TrailingSlashRedirector", "WorldServiceRedirect", "MvtEcho", "CircuitBreaker"]

  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
