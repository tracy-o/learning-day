defmodule Routes.Specs.WorldServiceMundoArticlePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: []
      }
    }
  end
end
