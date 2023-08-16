defmodule Routes.Specs.WorldServiceAfaanoromooTipoHomePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"]
        examples: ["/afaanoromoo", "/afaanoromoo.amp"]
      }
    }
  end
end
