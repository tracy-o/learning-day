defmodule Routes.Specs.NoEtagSupport do
  def specification do
    %{
      specs: %{
        owner: "Some owner",
        runbook: "Some runbook",
        platform: "MozartNews",
        etag: false
      }
    }
  end
end
