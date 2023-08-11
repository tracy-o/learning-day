defmodule Routes.Specs.AssetTypeWithMultipleSpecs do
  def specification do
    %{
      preflight_pipeline: ["AssetTypePlatformSelector"],
      specs: [
        %{
          owner: "Some guy",
          runbook: "Some runbook",
          platform: "Webcore",
          headers_allowlist: ["webcore-header"],
          query_params_allowlist: ["webcore_qparam"]
        },
        %{
          owner: "Some guy",
          runbook: "Some runbook",
          platform: "MozartNews",
          headers_allowlist: ["mozartnews-header"],
          query_params_allowlist: ["mozartnews_qparam"]
        }
      ]
    }
  end
end
