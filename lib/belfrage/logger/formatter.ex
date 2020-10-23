defmodule Belfrage.Logger.Formatter do
  def app(level, message, timestamp, metadata) do
    case Keyword.get(metadata, :cloudwatch) do
      true ->
        ""

      _ ->
        "#{message}\n"
    end
  rescue
    _ -> "could not format message: #{inspect({level, message, timestamp, metadata})}\n"
  end

  def cloudwatch(level, message, timestamp, metadata) do
    case Keyword.get(metadata, :cloudwatch) do
      true ->
        "#{message}\n"

      _ ->
        ""
    end
  rescue
    _ -> "could not format message: #{inspect({level, message, timestamp, metadata})}\n"
  end
end
