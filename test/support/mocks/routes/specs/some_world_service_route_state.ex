defmodule Routes.Specs.SomeWorldServiceRouteState do
  def specification do
    %{
      specs: %{
        email: "some@email.com",
        runbook: "Some runbook",
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        query_params_allowlist: ["query"]
      }
    }
  end
end
