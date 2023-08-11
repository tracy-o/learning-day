defmodule Routes.Specs.CacheDisabled do
  def specification do
    %{
      specs: %{
        owner: "Some guy",
        runbook: "Some runbook",
        platform: "Webcore",
        query_params_allowlist: ["query"],
        caching_enabled: false
      }
    }
  end
end
