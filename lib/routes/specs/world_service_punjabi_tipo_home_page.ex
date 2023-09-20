defmodule Routes.Specs.WorldServicePunjabiTipoHomePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/punjabi", "/punjabi.amp"]

      }
    }
  end
end
