defmodule Belfrage.Xray.ParseTrace do
  alias AwsExRay.Trace

  def parse(trace_header) do
    parts =
      trace_header
      |> String.split(";")
      |> Enum.map(&split_key_value/1)

    if :error in parts do
      {:error, :invalid}
    else
      parse_parts(parts)
    end
  end

  defp split_key_value(part) do
    case String.split(part, "=") do
      ["Sampled", sampled] -> parse_sampled(["Sampled", sampled])
      [key, value] -> [key, value]
      _ -> :error
    end
  end

  defp parse_parts(key_values) do
    case key_values do
      [["Root", root], ["Parent", parent], ["Sampled", sampled] | rest] ->
        {:ok, {Trace.with_params(root, sampled, parent), filter_extra_data(rest)}}

      [["Root", root], ["Sampled", sampled] | rest] ->
        {:ok, {Trace.with_params(root, sampled, ""), filter_extra_data(rest)}}

      [["Root", root] | rest] ->
        sampled = AwsExRay.Util.sample?()
        {:ok, {Trace.with_params(root, sampled, ""), filter_extra_data(rest)}}

      [["Self", _self], ["Root", root] | rest] ->
        sampled = AwsExRay.Util.sample?()
        {:ok, {Trace.with_params(root, sampled, ""), filter_extra_data(rest)}}

      _ ->
        {:error, :invalid}
    end
  end

  defp filter_extra_data(rest) do
    banned_keys = ["Self", "Root", "Parent", "Sampled"]

    Enum.filter(rest, &is_banned(&1, banned_keys))
  end

  defp is_banned([key, _value], banned_keys), do: key not in banned_keys
  defp is_banned(_, _banned_keys), do: false

  defp parse_sampled(["Sampled", "1"]), do: ["Sampled", true]
  defp parse_sampled(["Sampled", "0"]), do: ["Sampled", false]
  defp parse_sampled(_), do: :error
end
