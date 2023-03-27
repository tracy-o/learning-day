defmodule Routes.Specs.WorldServiceMarathiTipoHomePage do
  def specs do
    %{
      platform: "Simorgh",
      request_pipeline: ["WorldServiceRedirect"]
    }
  end
end
