defmodule JoeFormatter do
  use GenServer

  import ExUnit.Formatter,
  only: [format_time: 2, format_filters: 2, format_test_failure: 5, format_test_all_failure: 5]

  def init(opts) do
    {:ok, state} = ExUnit.CLIFormatter.init(opts)
    {:ok, Map.put(state, :failure_output, [])}
  end

  def handle_cast(arg = {:test_finished, test = %ExUnit.Test{state: {:excluded, _reason}}}, state) do
    {:noreply, state}
  end

  def handle_cast(arg = {:test_finished, test = %ExUnit.Test{state: {:failed, failures}}}, state) do
    #IO.inspect(test)

    counter = state.failure_counter + 1
    #format_test_failure(test, failures, counter, width, formatter) 
    line = IO.ANSI.red() <> "[🦑] #{test.name}" <>  IO.ANSI.reset()
    IO.puts line

    {:noreply, %{state|failure_counter: counter, failure_output: [line | state.failure_output]}}
  end

  def handle_cast(arg = {:test_finished, test}, state) do
    #IO.inspect(test)

    IO.puts  IO.ANSI.green() <> "[🐸] #{test.name}" <>  IO.ANSI.reset()

    #%{test_counter: {test: 10}} 
    {:noreply, %{state|test_counter: update_test_counter(state.test_counter, test)}}
  end

  def handle_cast({:suite_finished, _run_us , _load_us}, state) do
    #IO.inspect state
    IO.puts "Joes has finished"
    if (state.failure_output == []) do
      IO.puts "YOU PASSED"
    else
      IO.puts "YOU FAILED"
      IO.puts Enum.join(state.failure_output, "\n")
    end


    {:noreply, state}
  end

  defdelegate handle_cast(event, state), to: ExUnit.CLIFormatter

  defp update_test_counter(test_counter, %{tags: %{test_type: test_type}}) do
    Map.update(test_counter, test_type, 1, &(&1 + 1))
  end
end
