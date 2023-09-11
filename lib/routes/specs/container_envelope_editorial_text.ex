defmodule Routes.Specs.ContainerEnvelopeEditorialText do
  def specification(production_env) do
    %{
      specs: %{
        owner: "DENewsElections@bbc.co.uk",
        platform: "Webcore",
        request_pipeline: ["UserAgentValidator"],
        runbook: "https://confluence.dev.bbc.co.uk/display/connpol/Run+book+-+UK+2021",
        query_params_allowlist: query_params_allowlist(production_env),
        examples: [
          %{
            path: "/container/envelope/editorial-text/heading/Belfrage%20Test/headingLevel/2",
            headers: %{"user-agent" => "MozartFetcher"}
          },
          %{
            path: "/container/envelope/editorial-text/heading/Belfrage%20Test/headingLevel/2?static=true&mode=testData",
            headers: %{"user-agent" => "MozartFetcher"}
          }
        ]
      }
    }
  end

  defp query_params_allowlist("live"), do: ["static"]
  defp query_params_allowlist(_production_env), do: ["static", "mode"]

end
