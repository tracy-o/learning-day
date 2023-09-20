defmodule Routes.Specs.WorldServiceSinhalaTipoHomePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/sinhala", "/sinhala.amp"]
      }
    }
  end
end
