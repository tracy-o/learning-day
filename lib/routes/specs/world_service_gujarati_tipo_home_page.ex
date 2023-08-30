defmodule Routes.Specs.WorldServiceGujaratiTipoHomePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/gujarati", "/gujarati.amp"]
      }
    }
  end
end
