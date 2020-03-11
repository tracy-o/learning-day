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
      queryStringParameters: utf8_sanitise(struct.request.query_params),
      pathParameters: struct.request.path_params
    }
  end

  defp utf8_sanitise(params) do
    Enum.map(params, &key_value_pair_to_utf8/1)
    |> Enum.into(%{})
  end

  defp key_value_pair_to_utf8({key, value}) when is_map(value) do
    {
      Codepagex.from_string!(key, :iso_8859_1, Codepagex.use_utf_replacement()),
      utf8_sanitise(value)
    }
  end

  defp key_value_pair_to_utf8({key, value}) do
    {
      Codepagex.from_string!(key, :iso_8859_1, Codepagex.use_utf_replacement()),
      Codepagex.from_string!(value, :iso_8859_1, Codepagex.use_utf_replacement())
    }
  end
end
