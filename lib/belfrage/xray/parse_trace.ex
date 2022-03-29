defmodule Belfrage.Xray.ParseTrace do
  alias AwsExRay.Trace

  def parse(trace_header) do
    trace_header
    |> String.split(";")
    |> Enum.map(&split_key_value/1)
    |> parse_parts()
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
      [["Root", root], ["Parent", parent], ["Sampled", sampled]] ->
        {:ok, Trace.with_params(root, sampled, parent)}

      [["Root", root], ["Sampled", sampled]] ->
        {:ok, Trace.with_params(root, sampled, "")}

      _ ->
        {:error, :invalid}
    end
  end

  defp parse_sampled(["Sampled", "1"]), do: ["Sampled", true]
  defp parse_sampled(["Sampled", "0"]), do: ["Sampled", false]
  defp parse_sampled(_), do: :error
end
