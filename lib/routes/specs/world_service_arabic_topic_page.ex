defmodule Routes.Specs.WorldServiceArabicTopicPage do
  def specs do
    %{
      platform: Simorgh,
      pipeline: ["WorldServiceTopicsGuid"],
      query_params_allowlist: ["page"]
    }
  end
end
