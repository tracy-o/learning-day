defmodule Routes.Specs.WorldServiceTigrinyaTipoHomePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/tigrinya", "/tigrinya.amp"]
      }
    }
  end
end
