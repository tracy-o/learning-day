defmodule Routes.Specs.WorldServiceGahuzaAppArticlePage do
  def specs do
    %{
      platform: "Simorgh",
      request_pipeline: ["WorldServiceRedirect"]
    }
  end
end
