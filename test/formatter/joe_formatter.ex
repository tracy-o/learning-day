# custom test formatter, named after Joe's 2yr work anniversary
defmodule JoeFormatter do
  @moduledoc false
  use GenServer
  alias ExUnit.Test
  import ExUnit.Formatter, only: [format_test_failure: 5]

  def init(opts) do
    {:ok, config} = ExUnit.CLIFormatter.init(opts)
    {:ok, Map.put(config, :failed_tests, [])}
  end

  def handle_cast({:test_started, _} = event, %{trace: true} = config) do
    ExUnit.CLIFormatter.handle_cast(event, config)
    {:noreply, config}
  end

  # Do not count excluded/skipped/invalid tests to provide precise total tests executed (compared to ExUnit.CLIFormatter)
  def handle_cast({:test_finished, %Test{state: {:excluded, _}}}, %{trace: false} = config), do: {:noreply, config}
  def handle_cast({:test_finished, %Test{state: {:skipped, _}}}, %{trace: false} = config), do: {:noreply, config}
  def handle_cast({:test_finished, %Test{state: {:invalid, _}}}, %{trace: false} = config), do: {:noreply, config}

  def handle_cast({:test_finished, %Test{state: {:failed, _}} = test}, %{trace: false} = config) do
    print("[🦑] #{test.name}", :failed, config.colors[:enabled])

    {
      :noreply,
      %{
        config
        | test_counter: update_test_counter(config.test_counter, test),
          failure_counter: config.failure_counter + 1,
          failed_tests: [test | config.failed_tests]
      }
    }
  end

  def handle_cast({:test_finished, test}, %{trace: false} = config) do
    print("[🐸] #{test.name}", :success, config.colors[:enabled])
    {:noreply, %{config | test_counter: update_test_counter(config.test_counter, test)}}
  end

  def handle_cast({:suite_finished, _run_us, _load_us} = event, %{trace: false} = config) do
    config.failed_tests
    |> Enum.with_index()
    |> Enum.each(&print_failure(&1, config))

    ExUnit.CLIFormatter.handle_cast(event, config)

    {:noreply, config}
  end

  defdelegate handle_cast(event, config), to: ExUnit.CLIFormatter

  defp update_test_counter(test_counter, %{tags: %{test_type: test_type}}) do
    Map.update(test_counter, test_type, 1, &(&1 + 1))
  end

  defp print(line, :success, true), do: IO.puts(IO.ANSI.green() <> line <> IO.ANSI.reset())
  defp print(line, :failed, true), do: IO.puts(IO.ANSI.red() <> line <> IO.ANSI.reset())
  defp print(line, _outcome, false), do: IO.puts(line)

  defp print_failure({%Test{state: {:failed, reason}} = test, index}, config) do
    IO.puts("")
    IO.puts(format_test_failure(test, reason, index + 1, config.width, &formatter(&1, &2, config)))
  end

  # TODO: format failure / stacktrace with color schemes
  # based on message type :test_info, :location_info,
  # :diff_enabled?, :error_info, stacktrace_info
  defp formatter(_type, msg, _config), do: msg
end
