defmodule Routes.Specs.WorldServiceTurkceTipoHomePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/turkce", "/turkce.amp"]
      }
    }
  end
end
