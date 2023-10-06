defmodule Routes.Specs.WorldServiceUkrainianTipoHomePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/ukrainian", "/ukrainian.amp"]
      }
    }
  end
end
