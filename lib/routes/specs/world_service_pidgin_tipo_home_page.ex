defmodule Routes.Specs.WorldServicePidginTipoHomePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/pidgin", "/pidgin.amp"]
      }
    }
  end
end
