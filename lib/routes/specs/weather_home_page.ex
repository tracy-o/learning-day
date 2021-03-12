defmodule Routes.Specs.WeatherHomePage do
  def specs(production_env) do
    %{
      owner: "DENewsElections@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/pages/viewpage.action?pageId=140399154",
      platform: MozartWeather,
      pipeline: pipeline(production_env),
      headers_allowlist: ["cookie-ckps_language"]
    }
  end

  defp pipeline("live"), do: ["HTTPredirect", "TrailingSlashRedirector", "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
