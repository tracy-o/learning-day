defmodule Routes.Specs.DotComCulture do
  def specification do
    %{
      preflight_pipeline: ["BBCXCulturePlatformSelector"],
      specs: [
        %{
          platform: "DotComCulture",
          examples: ["/culture", "/culture/tags/jazz-music"]
        },
        %{
          platform: "BBCX"
        },
      ]
    }
  end
end
