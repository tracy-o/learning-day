defmodule Routes.Specs.ContainerEnvelopeWinnerFlash do
  def specification(production_env) do
    %{
      specs: %{
        owner: "DENewsElections@bbc.co.uk",
        platform: "Webcore",
        request_pipeline: ["UserAgentValidator"],
        runbook: "https://confluence.dev.bbc.co.uk/display/connpol/Run+book+-+UK+2022",
        query_params_allowlist: query_params_allowlist(production_env),
        examples: [
          %{
            path: "/container/envelope/winner-flash/assetUri/%2Fnews%2Felection%2F2021%2Fscotland%2Fconstituencies%2FS16000084/hasFetcher/true",
            request_headers: %{"user-agent" => "MozartFetcher"}
          },
          %{
            path: "/container/envelope/winner-flash/assetUri/%2Fnews%2Felection%2F2021%2Fscotland%2Fconstituencies%2FS16000084/hasFetcher/true?static=true&mode=testData",
            request_headers: %{"user-agent" => "MozartFetcher"}
          },
        ]
      }
    }
  end

  defp query_params_allowlist("live"), do: ["static"]
  defp query_params_allowlist(_production_env), do: ["static", "mode"]

end
