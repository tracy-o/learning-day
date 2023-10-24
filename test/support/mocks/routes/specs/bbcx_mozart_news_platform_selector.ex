defmodule Routes.Specs.BBCXMozartNewsPlatformSelector do
  def specification do
    %{
      preflight_pipeline: ["BBCXMozartNewsPlatformSelector"],
      specs: [
        %{
          platform: "MozartNews",
          email: "some@email.com",
          runbook: "Some runbook"
        },
        %{
          platform: "BBCX",
          email: "some@email.com",
          runbook: "Some runbook"
        }
      ]
    }
  end
end
