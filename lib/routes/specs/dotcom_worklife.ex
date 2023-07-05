defmodule Routes.Specs.DotComWorklife do
  def specification do
    %{
      preflight_pipeline: ["BBCXWorklifePlatformSelector"],
      specs: [
        %{
          platform: "DotComWorklife",
          examples: ["/worklife"]
        },
        %{
          platform: "BBCX"
        }
      ]
    }
  end
end
