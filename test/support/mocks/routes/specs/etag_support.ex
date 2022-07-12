defmodule Routes.Specs.EtagSupport do
  def specs do
    %{
      owner: "Some owner",
      runbook: "Some runbook",
      platform: MozartNews,
      headers_allowlist: ["if-none-match"],
      put_etag: true
    }
  end
end
