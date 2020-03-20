defmodule Routes.Specs.SportPal do
  def specs do
    %{
      platform: Pal,
      query_params_allowlist: ["show-service-calls"]
    }
  end
end
