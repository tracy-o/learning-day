defmodule Routes.Specs.EtagSupport do
  def specification do
    %{
      specs: %{
        email: "some@email.com",
        runbook: "Some runbook",
        platform: "MozartNews",
        headers_allowlist: ["if-none-match"],
        response_pipeline: ["Etag"],
        etag: true
      }
    }
  end
end
