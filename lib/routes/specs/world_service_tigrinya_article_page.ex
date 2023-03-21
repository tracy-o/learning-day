defmodule Routes.Specs.WorldServiceTigrinyaArticlePage do
  def specs do
    %{
      platform: "Simorgh",
      request_pipeline: ["WorldServiceRedirect"]
    }
  end
end
