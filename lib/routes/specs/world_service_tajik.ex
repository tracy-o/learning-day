defmodule Routes.Specs.WorldServiceTajik do
  def specs do
    %{
      platform: MozartNews,
      request_pipeline: ["WorldServiceRedirect"]
    }
  end
end
