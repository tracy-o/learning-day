defmodule Routes.Specs.BreakingNews do
  def specification do
    %{
      specs: %{
        platform: "MozartNews",
        fallback_write_sample: 0.0,
        examples: ["/news/breaking-news/audience/domestic", "/news/breaking-news/audience/us", "/news/breaking-news/audience/international", "/news/breaking-news/audience/asia"]
      }
    }
  end
end
