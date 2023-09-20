defmodule Routes.Specs.WorldServiceGahuzaTipoHomePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/gahuza", "/gahuza.amp"]
      }
    }
  end
end
