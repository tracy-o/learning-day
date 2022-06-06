defmodule Routes.Specs.WorldServiceUkchinaTopicPage do
  def specs do
    %{
      platform: Simorgh,
      pipeline: ["WorldServiceTopicsGuid"],
      query_params_allowlist: ["page"],
      headers_allowlist: ["cookie-ckps_chinese"]
    }
  end
end
