defmodule Routes.Specs.WorldServiceBurmeseTipoHomePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/burmese", "/burmese.amp"]
      }
    }
  end
end
