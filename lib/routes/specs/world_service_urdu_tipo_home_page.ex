defmodule Routes.Specs.WorldServiceUrduTipoHomePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/urdu", "/urdu.amp"]
      }
    }
  end
end
