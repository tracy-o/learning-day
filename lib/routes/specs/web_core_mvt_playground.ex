defmodule Routes.Specs.WebCoreMvtPlayground do
  def specs do
    %{
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      platform: Webcore,
      pipeline: ["MvtMapper"],
      headers_allowlist: mvt_headers(),
      caching_enabled: false
    }
  end

  defp mvt_headers do
    1..20
    |> Enum.map(fn i -> "bbc-mvt-#{i}" end)
    |> Enum.concat(["bbc-mvt-complete"])
  end
end
