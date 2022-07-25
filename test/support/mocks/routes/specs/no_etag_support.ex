defmodule Routes.Specs.NoEtagSupport do
  def specs do
    %{
      owner: "Some owner",
      runbook: "Some runbook",
      platform: MozartNews,
      etag: false
    }
  end
end
