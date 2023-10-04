defmodule Routes.Specs.WorldServiceVietnameseTipoHomePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/vietnamese", "/vietnamese.amp"]
      }
    }
  end
end
