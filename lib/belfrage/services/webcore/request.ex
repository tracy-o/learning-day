defmodule Belfrage.Services.Webcore.Request do
  alias Belfrage.Services.Webcore.Helpers.Utf8Sanitiser

  def build(struct) do
    %{
      headers: %{
        country: struct.request.country,
        "accept-encoding": "gzip",
        is_uk: struct.request.is_uk,
        host: struct.request.host
      },
      body: struct.request.payload,
      httpMethod: struct.request.method,
      path: struct.request.path,
      queryStringParameters: Utf8Sanitiser.utf8_sanitise_query_params(struct.request.query_params),
      pathParameters: struct.request.path_params
    }
  end
end
