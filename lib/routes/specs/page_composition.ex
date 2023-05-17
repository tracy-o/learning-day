defmodule Routes.Specs.PageComposition do
  def specification do
    %{
      specs: %{
        platform: "Webcore",
        query_params_allowlist: ["path", "params", "query"]
      }
    }
  end
end
