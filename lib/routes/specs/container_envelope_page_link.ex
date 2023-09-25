defmodule Routes.Specs.ContainerEnvelopePageLink do
  def specification do
    %{
      specs: %{
        owner: "DENewsElections@bbc.co.uk",
        platform: "Webcore",
        request_pipeline: ["UserAgentValidator"],
        runbook: "https://confluence.dev.bbc.co.uk/display/connpol/Run+book+-+UK+2021",
        query_params_allowlist: ["static"],
        examples: [
          %{
            path: "/container/envelope/page-link/linkHref/%23belfrage/linkLabel/Belfrage%20Test",
            request_headers: %{"user-agent" => "MozartFetcher"}
          }
        ]
      }
    }
  end
end
