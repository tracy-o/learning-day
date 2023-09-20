defmodule Routes.Specs.WorldServiceNepaliTipoHomePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/nepali", "/nepali.amp"]
      }
    }
  end
end
