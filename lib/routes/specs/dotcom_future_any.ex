defmodule Routes.Specs.DotComFutureAny do
  def specification do
    %{
      specs: %{
        platform: "DotComFuture",
        examples: ["/future", "/future/tags", "/future/columns"]
      }
    }
  end
end
