defmodule Routes.Specs.WorldServiceThaiTipoHomePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/thai", "/thai.amp"]
      }
    }
  end
end
