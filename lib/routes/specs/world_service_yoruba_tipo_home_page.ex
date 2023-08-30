defmodule Routes.Specs.WorldServiceYorubaTipoHomePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/yoruba", "/yoruba.amp"]
      }
    }
  end
end
