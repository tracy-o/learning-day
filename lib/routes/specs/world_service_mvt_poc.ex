defmodule Routes.Specs.WorldServiceMvtPoc do
  def specification(production_env) do
    %{
      specs: %{
        owner: "DENewsFrameworksTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
        platform: "MozartSimorgh",
        request_pipeline: pipeline(production_env),
        headers_allowlist: mvt_headers(),
        caching_enabled: false
      }
    }
  end

  defp mvt_headers do
    1..20
    |> Enum.map(fn i -> "bbc-mvt-#{i}" end)
    |> Enum.concat(["bbc-mvt-complete"])
  end

  defp pipeline("live"),
    do: ["WorldServiceRedirect", "MvtEcho", "CircuitBreaker"]

  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
