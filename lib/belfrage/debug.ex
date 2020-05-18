if Mix.env() == :prod do
  defmodule Belfrage.Debug do
    def enable_debug_mode, do: set_level(:debug)
    def disable_debug_mode, do: set_level(:error)

    defp set_level(debug_level) do
      debug_opts = Keyword.put(debug_opts(), :level, debug_level)

      Logger.configure_backend({LoggerFileBackend, :file}, debug_opts)
    end

    defp debug_opts do
      Application.get_env(:logger, :file)
    end
  end
end
