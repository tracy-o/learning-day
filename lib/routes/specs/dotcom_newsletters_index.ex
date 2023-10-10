defmodule Routes.Specs.DotComNewslettersIndex do
  def specification do
    %{
      specs: %{
        request_pipeline: ["DotComRedirect"],
        platform: "DotComNewsletters"
      }
    }
  end
end
