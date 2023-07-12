defmodule Routes.Specs.WorldServiceAzeriTipoHomePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/azeri", "/azeri.amp"]
      }
    }
  end
end
