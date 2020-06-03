defmodule Belfrage.PII do
  @moduledoc """
  Redact personal information from headers
  """
  def clean(headers = %{}) do
    Enum.map(headers, &maybe_redact/1)
  end

  def clean(headers, acc \\ [])
  def clean([], acc), do: acc

  def clean([header | rest], acc) do
    clean(rest, [maybe_redact(header) | acc])
  end

  defp maybe_redact({key, value}) do
    case String.contains?(key, ["cookie", "ssl"]) do
      true -> {key, "REDACTED"}
      false -> {key, value}
    end
  end
end
