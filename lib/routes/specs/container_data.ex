defmodule Routes.Specs.ContainerData do
  def specification do
    %{
      specs: %{
        platform: "Webcore",
        query_params_allowlist: "*",
        examples: ["/wc-data/p/container/consent-banner", "/wc-data/container/consent-banner"]
      }
    }
  end
end
