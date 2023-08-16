defmodule Routes.Specs.WorldServiceAmharicTipoHomePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/amharic", "/amharic.amp"]
      }
    }
  end
end
