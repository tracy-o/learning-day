defmodule Routes.Specs.WorldServiceJapanese do
  def specification do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/japanese/popular/read", "/japanese.json", "/japanese.amp"]
      }
    }
  end
end
