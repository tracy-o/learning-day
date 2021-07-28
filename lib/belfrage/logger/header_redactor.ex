defmodule Belfrage.Logger.HeaderRedactor do
  @moduledoc """
  Redacts personal or unnecessary information from headers when logging
  """

  @redacted_headers ["cookie", "ssl", "content-security-policy", "feature-policy", "report-to"]

  def redact(headers = %{}) do
    Enum.map(headers, &maybe_redact/1)
  end

  def redact(headers, acc \\ [])
  def redact([], acc), do: acc

  def redact([header | rest], acc) do
    redact(rest, [maybe_redact(header) | acc])
  end

  defp maybe_redact({key, value}) do
    case String.contains?(key, @redacted_headers) do
      true -> {key, "REDACTED"}
      false -> {key, value}
    end
  end
end
