defmodule Routes.Specs.EtagSupport do
  def specs do
    %{
      owner: "Some owner",
      runbook: "Some runbook",
      platform: MozartNews,
      headers_allowlist: ["if-none-match"],
      response_pipeline: ["Etag"],
      etag: true
    }
  end
end
