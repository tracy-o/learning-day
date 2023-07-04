defmodule Routes.Specs.DotComCulture do
  def specification do
    %{
      preflight_pipeline: [BBCXCulturePlatformSelector],
      specs: [
        %{
          request_pipeline: [],
          platform: "DotComCulture",
          examples: ["/culture"]
        },
        %{
          platform: "BBCX"
        },
      ]
    }
  end
end
