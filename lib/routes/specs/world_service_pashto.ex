defmodule Routes.Specs.WorldServicePashto do
  def specification do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/pashto/popular/read", "/pashto.json", "/pashto.amp"]
      }
    }
  end
end
