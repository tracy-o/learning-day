defmodule Routes.Specs.WorldServiceKorean do
  def specification do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/korean/popular/read", "/korean.json", "/korean.amp"]
      }
    }
  end
end
