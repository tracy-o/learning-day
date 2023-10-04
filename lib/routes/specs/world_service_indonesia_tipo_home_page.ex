defmodule Routes.Specs.WorldServiceIndonesiaTipoHomePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/indonesia", "/indonesia.amp"]
      }
    }
  end
end
