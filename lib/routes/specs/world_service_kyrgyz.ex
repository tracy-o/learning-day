defmodule Routes.Specs.WorldServiceKyrgyz do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/kyrgyz/popular/read"]
      }
    }
  end
end
