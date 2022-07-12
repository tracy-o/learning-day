defmodule Routes.Specs.NoEtagSupport do
  def specs do
    %{
      owner: "Some owner",
      runbook: "Some runbook",
      platform: MozartNews,
      put_etag: false
    }
  end
end
