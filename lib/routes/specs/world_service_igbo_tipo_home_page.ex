defmodule Routes.Specs.WorldServiceIgboTipoHomePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/igbo", "/igbo.amp"]
      }
    }
  end
end
