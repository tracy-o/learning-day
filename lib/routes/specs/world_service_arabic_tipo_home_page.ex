defmodule Routes.Specs.WorldServiceArabicTipoHomePage do
  def specs do
    %{
      platform: "Simorgh",
      request_pipeline: ["WorldServiceRedirect"]
    }
  end
end
