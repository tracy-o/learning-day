defmodule Routes.Specs.ContainerEnvelopeNavigationLinks do
  def specs do
    %{
      owner: "DEWeather@bbc.co.uk",
      platform: "Webcore",
      request_pipeline: ["UserAgentValidator"],
      runbook: "https://confluence.dev.bbc.co.uk/pages/viewpage.action?pageId=140399154",
      query_params_allowlist: ["static"]
    }
  end
end
