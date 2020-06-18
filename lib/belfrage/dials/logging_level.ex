defmodule Belfrage.Dials.LoggingLevel do
  def on_refresh(dials) do
    dials
    |> Map.get("logging_level", "default")
    |> set_level()
  end

  defp set_level(dial_value) do
    dial = String.to_atom(dial_value)

    if dial in [:debug, :info, :warn, :error] do
      Logger.configure(level: dial)
    end

    Logger.level()
  end
end
