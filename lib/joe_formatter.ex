defmodule JoeFormatter do
  use GenServer

  import ExUnit.Formatter,
  only: [format_time: 2, format_filters: 2, format_test_failure: 5, format_test_all_failure: 5]

  def init(opts) do
    {:ok, config} = ExUnit.CLIFormatter.init(opts)
    {:ok, Map.put(config, :failure_output, [])}
  end

  def handle_cast(arg = {:test_finished, test = %ExUnit.Test{state: {:excluded, _reason}}}, config) do
    {:noreply, config}
  end

  def handle_cast(arg = {:test_finished, test = %ExUnit.Test{state: {:failed, failures}}}, config) do
    #IO.inspect(test)

    counter = config.failure_counter + 1
    #format_test_failure(test, failures, counter, width, formatter) 
    line = IO.ANSI.red() <> "[🦑] #{test.name}" <>  IO.ANSI.reset()
    IO.puts line

    {:noreply, %{config|failure_counter: counter, failure_output: [line | config.failure_output]}}
  end

  def handle_cast(arg = {:test_finished, test}, config) do
    #IO.inspect(test)

    IO.puts  IO.ANSI.green() <> "[🐸] #{test.name}" <>  IO.ANSI.reset()

    #%{test_counter: {test: 10}} 
    {:noreply, %{config|test_counter: update_test_counter(config.test_counter, test)}}
  end

  def handle_cast({:suite_finished, _run_us , _load_us}, config) do
    IO.puts "Joes has finished"
    if (config.failure_output == []) do
      IO.puts "YOU PASSED"
    else
      IO.puts "YOU FAILED"
      IO.puts Enum.join(config.failure_output, "\n")
    end


    {:noreply, config}
  end

  defdelegate handle_cast(event, config), to: ExUnit.CLIFormatter

  defp update_test_counter(test_counter, %{tags: %{test_type: test_type}}) do
    Map.update(test_counter, test_type, 1, &(&1 + 1))
  end
end
