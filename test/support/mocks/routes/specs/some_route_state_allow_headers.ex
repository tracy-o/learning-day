defmodule Routes.Specs.SomeRouteStateAllowHeaders do
  def specification do
    %{
      specs: %{
        owner: "Some person",
        runbook: "Some runbook",
        platform: "Webcore",
        headers_allowlist: ["one_header", "cookie", "another_header"]
      }
    }
  end
end
