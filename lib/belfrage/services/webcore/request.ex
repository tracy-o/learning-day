defmodule Belfrage.Services.Webcore.Request do
  def build(struct) do
    %{
      headers: %{
        country: struct.request.country
      },
      body: struct.request.payload,
      httpMethod: struct.request.method,
      path: struct.request.path,
      queryStringParameters: struct.request.query_params,
      pathParameters: struct.request.path_params
    }
  end
end
