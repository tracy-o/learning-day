defmodule Routes.Specs.WorldServiceBengaliTipoHomePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/bengali", "/bengali.amp"]

      }
    }
  end
end
