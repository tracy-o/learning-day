defmodule Belfrage.Services.Webcore.Helpers.Utf8Sanitiser do
  def utf8_sanitise_query_params(params) do
    Enum.map(params, &key_value_pair_to_utf8/1)
    |> Enum.into(%{})
  end

  defp key_value_pair_to_utf8({key, value}) when is_map(value),
    do: {replace_invalid_bytes(key), utf8_sanitise_query_params(value)}

  defp key_value_pair_to_utf8({key, value}), do: {replace_invalid_bytes(key), replace_invalid_bytes(value)}

  defp replace_invalid_bytes(input_string, sanitised_string_accumulator \\ [])

  defp replace_invalid_bytes(<<good::utf8, rest::binary>>, acc), do: replace_invalid_bytes(rest, [<<good::utf8>> | acc])
  defp replace_invalid_bytes(<<_bad::size(8), rest::binary>>, acc), do: replace_invalid_bytes(rest, ["�" | acc])
  defp replace_invalid_bytes(<<>>, acc), do: acc |> Enum.reverse() |> Enum.join()
end
