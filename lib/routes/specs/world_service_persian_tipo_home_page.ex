defmodule Routes.Specs.WorldServicePersianTipoHomePage do
  def specs do
    %{
      platform: "Simorgh",
      request_pipeline: ["WorldServiceRedirect"]
    }
  end
end
