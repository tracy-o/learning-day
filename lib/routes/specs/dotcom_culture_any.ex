defmodule Routes.Specs.DotComCultureAny do
  def specification do
    %{
      specs: %{
        request_pipeline: [],
        platform: "DotComCulture",
        examples: ["/culture/tags", "/culture/columns/music"]
      }
    }
  end
end
