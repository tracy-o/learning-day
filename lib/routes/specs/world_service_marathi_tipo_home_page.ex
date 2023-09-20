defmodule Routes.Specs.WorldServiceMarathiTipoHomePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/marathi", "/marathi.amp"]

      }
    }
  end
end
