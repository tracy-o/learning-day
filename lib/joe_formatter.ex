defmodule JoeFormatter do
  @moduledoc false
  use GenServer
  alias ExUnit.Test

  def init(opts) do
    {:ok, config} = ExUnit.CLIFormatter.init(opts)
    {:ok, Map.put(config, :failure_output, [])}
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
    line = "[🦑] #{test.name}"
    print(line, :failed, config.colors[:enabled])

    {
      :noreply,
      %{
        config
        | test_counter: update_test_counter(config.test_counter, test),
          failure_counter: config.failure_counter + 1,
          failure_output: [line | config.failure_output]
      }
    }
  end

  def handle_cast({:test_finished, test}, %{trace: false} = config) do
    print("[🐸] #{test.name}", :success, config.colors[:enabled])
    {:noreply, %{config | test_counter: update_test_counter(config.test_counter, test)}}
  end

  def handle_cast({:suite_finished, _run_us, _load_us} = event, %{trace: false} = config) do
    if config.failure_output == [] do
      IO.puts("YOU PASSED")
    else
      IO.puts("YOU FAILED")
      IO.puts(Enum.join(config.failure_output, "\n"))
    end

    ExUnit.CLIFormatter.handle_cast(event, config)

    {:noreply, config}
  end

  defdelegate handle_cast(event, config), to: ExUnit.CLIFormatter

  defp update_test_counter(test_counter, %{tags: %{test_type: test_type}}) do
    Map.update(test_counter, test_type, 1, &(&1 + 1))
  end

  defp print(line, outcome \\ :success, color_enabled? \\ false)
  defp print(line, :success, true), do: IO.puts(IO.ANSI.green() <> line <> IO.ANSI.reset())
  defp print(line, :failed, true), do: IO.puts(IO.ANSI.red() <> line <> IO.ANSI.reset())
  defp print(line, _outcome, false), do: IO.puts(line)
end
