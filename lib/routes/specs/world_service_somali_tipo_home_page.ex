defmodule Routes.Specs.WorldServiceSomaliTipoHomePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/somali", "/somali.amp"]
      }
    }
  end
end
