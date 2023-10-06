defmodule Routes.Specs.WorldServicePortugueseTipoHomePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/portuguese", "/portuguese.amp"]
      }
    }
  end
end
