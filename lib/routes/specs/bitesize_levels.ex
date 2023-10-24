defmodule Routes.Specs.BitesizeLevels do
  def specification do
    %{
      specs: %{
        email: "bitesize-production@lists.forge.bbc.co.uk",
        platform: "MorphRouter",
        language_from_cookie: true,
        request_pipeline: ["ComToUKRedirect", "BitesizeLevelsPlatformDiscriminator", "LambdaOriginAlias", "Language"],
        examples: [
          %{
            path: "/bitesize/levels/z3g4d2p/year/zjpqqp3",
            request_headers: %{"x-forwarded-host" => "www.bbc.co.uk"}
          },
          %{
            path: "/bitesize/levels/zr48q6f",
            request_headers: %{"x-forwarded-host" => "www.bbc.co.uk"}
          }
        ]
      }
    }
  end
end
