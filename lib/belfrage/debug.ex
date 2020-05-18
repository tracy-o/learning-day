if Mix.env() == :prod do
  defmodule Belfrage.Debug do
    @moduledoc """
    Enable and disable debug mode in production builds.

    This is to be ran via an `rpc` call. For example:

    To enable:
    _build/prod/rel/belfrage/bin/belfrage rpc "Elixir.Belfrage.Debug.enable()"

    To disable:
    _build/prod/rel/belfrage/bin/belfrage rpc "Elixir.Belfrage.Debug.disable()"
    """

    def enable, do: set_level(:debug)
    def disable, do: set_level(:error)

    defp set_level(debug_level) do
      debug_opts = Keyword.put(debug_opts(), :level, debug_level)

      Logger.configure_backend({LoggerFileBackend, :file}, debug_opts)
    end

    defp debug_opts do
      Application.get_env(:logger, :file)
    end
  end
end
