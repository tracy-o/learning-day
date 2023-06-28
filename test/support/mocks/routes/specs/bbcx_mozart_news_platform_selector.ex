defmodule Routes.Specs.BBCXMozartNewsPlatformSelector do
  def specification do
    %{
      preflight_pipeline: ["BBCXMozartNewsPlatformSelector"],
      specs: [
        %{
          platform: "MozartNews",
          owner: "Some person",
          runbook: "Some runbook"
        },
        %{
          platform: "BBCX",
          owner: "Some person",
          runbook: "Some runbook"
        }
      ]
    }
  end
end
