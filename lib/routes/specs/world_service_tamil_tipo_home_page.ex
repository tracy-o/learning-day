defmodule Routes.Specs.WorldServiceTamilTipoHomePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/tamil", "/tamil.amp"]

      }
    }
  end
end
