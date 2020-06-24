defmodule Belfrage.Dials.LoggingLevel do
  def on_refresh(dials) do
    dials
    |> Map.get("logging_level")
    |> set_level()
  end

  defp set_level(dial_value) do
    if dial_value in ["debug", "info", "warn", "error"] do
      Logger.configure(level: String.to_atom(dial_value))
    else
      Stump.log(:error, "Tried to set invalid logging level.")
    end

    Logger.level()
  end
end
