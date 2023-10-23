defmodule Routes.Specs.WorldServiceKyrgyz do
  def specification do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/kyrgyz/popular/read"]
      }
    }
  end
end
