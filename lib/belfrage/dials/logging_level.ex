defmodule Belfrage.Dials.LoggingLevel do
  def on_refresh(dials) do
    dials
    |> Map.get("logging_level")
    |> set_level()
  end

  defp set_level(dial_value) do
    if dial_value in ["debug", "info", "warn", "error"] do
      Logger.configure_backend({LoggerFileBackend, :file}, logger_opts(dial_value))
      :ok
    else
      Stump.log(:error, "Tried to set invalid logging level.")
      {:error, "Invalid logging level"}
    end
  end

  def logger_opts(dial_value) do
    Application.get_env(:logger, :file)
    |> Keyword.put(:level, String.to_atom(dial_value))
  end
end
