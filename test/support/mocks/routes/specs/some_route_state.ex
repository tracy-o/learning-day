defmodule Routes.Specs.SomeRouteState do
  def specification do
    %{
      specs: %{
        email: "some@email.com",
        runbook: "Some runbook",
        platform: "Webcore",
        query_params_allowlist: ["query"]
      }
    }
  end
end
