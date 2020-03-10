defmodule Belfrage.Services.Webcore.Request do
  def build(struct) do
    %{
      headers: %{
        country: struct.request.country,
        "accept-encoding": "gzip"
      },
      body: struct.request.payload,
      httpMethod: struct.request.method,
      path: struct.request.path,
      queryStringParameters: uri_encode(struct.request.query_params),
      pathParameters: struct.request.path_params
    }
  end

  defp uri_encode(params) do
    Enum.map(
      params,
      fn
        {k, v} when is_map(v) -> {URI.encode_www_form(k), uri_encode(v)}
        {k, v} -> {URI.encode_www_form(k), URI.encode_www_form(v)}
      end
    )
    |> Enum.into(%{})
  end
end
