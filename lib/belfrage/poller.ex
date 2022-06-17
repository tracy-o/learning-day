defmodule Belfrage.Poller do
  @callback poll() :: :ok

  # When this module is used with 'use Belfrage.Poller'
  # this __using__ macro will inject the following GenServer code.
  # If we use @impl in the caller module, we can also enforce that
  # a poll/0 function is present.
  # For example:
  #
  #     defmodule SomePoller do
  #       alias TestAgent
  #       use Belfrage.Poller, interval: 60 # we can set an interval in ms with this keyword
  #       @impl Belfrage.Poller # enforces that a poll/0 function exists
  #       def poll() do
  #         TestAgent.set()
  #         :ok
  #       end
  #     end
  defmacro __using__(poller_opts) do
    poller_opts = poller_opts ++ [caller_module: __CALLER__.module]

    quote bind_quoted: [poller_opts: poller_opts] do
      @behaviour Belfrage.Poller
      use GenServer
      require Logger

      def start_link(opts) do
        GenServer.start_link(__MODULE__, Keyword.fetch!(unquote(poller_opts), :interval),
          name: Keyword.get(opts, :name, caller_module())
        )
      end

      @impl GenServer
      def init(interval) do
        poll_safely()
        schedule_polling(interval)

        {:ok, interval}
      end

      @impl GenServer
      def handle_info(:poll, interval) do
        poll_safely()
        schedule_polling(interval)

        {:noreply, interval}
      end

      def poll(), do: :ok

      defp schedule_polling(interval) do
        Process.send_after(self(), :poll, interval)
      end

      defp poll_safely() do
        try do
          poll()
        catch
          value ->
            Logger.log(:error, "#{caller_module()} failed to poll, the following value was caught: #{inspect(value)}")

          :exit, e ->
            Logger.log(:error, "#{caller_module()} failed to poll, process exited: #{inspect(e)}")

          :error, e ->
            Logger.log(:error, "#{caller_module()} failed to poll, the following error was rescued: #{inspect(e)}")
        end
      end

      defp caller_module() do
        Keyword.fetch!(unquote(poller_opts), :caller_module)
      end

      defoverridable poll: 0
    end
  end
end
