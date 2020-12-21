defmodule Belfrage.Dials.LoggingLevel do
  @moduledoc false

  @behaviour Belfrage.Dial.Client

  @valid_dial_values ["debug", "info", "warn", "error"]
  @valid_levels Enum.map(@valid_dial_values, &String.to_atom/1)

  @impl Belfrage.Dial.Client
  def transform(level) when level in @valid_dial_values, do: String.to_atom(level)

  @impl Belfrage.Dial.Client
  def on_change(dial_value) when dial_value in @valid_levels do
    Logger.configure_backend({LoggerFileBackend, :file}, logger_opts(dial_value))
    :ok
  end

  defp logger_opts(dial_value) do
    Application.get_env(:logger, :file)
    |> Keyword.put(:level, dial_value)
  end
end
