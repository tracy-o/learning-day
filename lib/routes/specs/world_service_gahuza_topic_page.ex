defmodule Routes.Specs.WorldServiceGahuzaTopicPage do
  def specs do
    %{
      platform: Simorgh,
      query_params_allowlist: ["page"]
    }
  end
end
