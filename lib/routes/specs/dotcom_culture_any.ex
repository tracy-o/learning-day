defmodule Routes.Specs.DotComCultureAny do
  def specification do
    %{
      specs: %{
        platform: "DotComCulture",
        examples: ["/culture/tags", "/culture/columns/music"]
      }
    }
  end
end
