defmodule Routes.Specs.DotComWorklife do
  def specification do
    %{
      preflight_pipeline: ["BBCXWorklifePlatformSelector"],
      specs: [
        %{
          platform: "DotComWorklife",
          examples: [
            "/worklife/article/20230731-why-twitters-rebrand-to-x-feels-shocking-to-users",
            "/worklife/tags/business"
          ]
        },
        %{
          platform: "BBCX",
          examples: [
            "/worklife/article/20230731-why-twitters-rebrand-to-x-feels-shocking-to-users",
            "/worklife/tags/business"
          ]
        }
      ]
    }
  end
end
