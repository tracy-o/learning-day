defmodule Routes.Specs.WorldServiceTeluguTipoHomePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/telugu", "/telugu.amp"]

      }
    }
  end
end
