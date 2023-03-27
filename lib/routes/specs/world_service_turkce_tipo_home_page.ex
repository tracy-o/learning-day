defmodule Routes.Specs.WorldServiceTurkceTipoHomePage do
  def specs do
    %{
      platform: "Simorgh",
      request_pipeline: ["WorldServiceRedirect"]
    }
  end
end
