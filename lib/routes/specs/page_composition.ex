defmodule Routes.Specs.PageComposition do
  def specification do
    %{
      specs: %{
        platform: "Webcore",
        query_params_allowlist: ["path", "params", "query"],
        examples: ["/wc-data/page-composition?path=/search&params=%7B%7D"]
      }
    }
  end
end
