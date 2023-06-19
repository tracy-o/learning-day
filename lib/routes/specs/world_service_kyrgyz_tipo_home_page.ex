defmodule Routes.Specs.WorldServiceKyrgyzTipoHomePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/kyrgyz", "/kyrgyz.amp"]
      }
    }
  end
end
