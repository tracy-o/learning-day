defmodule Routes.Specs.DotComFutureAny do
  def specification do
    %{
      specs: %{
        request_pipeline: [],
        platform: "DotComFuture",
        examples: ["/future/tags", "/future/columns/the-lost-index/"]
      }
    }
  end
end
