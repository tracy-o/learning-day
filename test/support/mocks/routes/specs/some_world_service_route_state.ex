defmodule Routes.Specs.SomeWorldServiceRouteState do
  def specs do
    %{
      owner: "Some guy",
      runbook: "Some runbook",
      platform: MozartSimorgh,
      pipeline: ["WorldServiceRedirect"],
      query_params_allowlist: ["query"]
    }
  end
end
