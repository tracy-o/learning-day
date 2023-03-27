defmodule Routes.Specs.WorldServiceSerbianTipoHomePage do
  def specs do
    %{
      platform: "Simorgh",
      request_pipeline: ["WorldServiceRedirect"]
    }
  end
end
