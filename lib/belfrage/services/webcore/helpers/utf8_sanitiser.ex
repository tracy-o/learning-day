defmodule Belfrage.Services.Webcore.Helpers.Utf8Sanitiser do
  def utf8_sanitise_query_params(params) do
    Enum.map(params, &key_value_pair_to_utf8/1)
    |> Enum.into(%{})
  end

  defp key_value_pair_to_utf8({key, value}) when is_map(value),
    do: {string_to_utf8(key), utf8_sanitise_query_params(value)}

  defp key_value_pair_to_utf8({key, value}), do: {string_to_utf8(key), string_to_utf8(value)}

  defp string_to_utf8(s) do
    case String.valid?(s) do
      true -> s
      false -> deal_with_invalid_chars(s)
    end
  end

  defp deal_with_invalid_chars(s) do
    Enum.map(
      :binary.bin_to_list(s),
      fn char ->
        case String.valid?(<<char>>) do
          true -> <<char>>
          false -> "�"
        end
      end
    )
    |> Enum.join()
  end
end
