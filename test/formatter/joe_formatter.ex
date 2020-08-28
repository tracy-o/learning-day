# custom test formatter, named after Joe's 2yr work anniversary
defmodule JoeFormatter do
  @moduledoc false
  use GenServer
  alias ExUnit.Test
  import ExUnit.Formatter, only: [format_test_failure: 5, format_time: 2]

  def init(opts) do
    {:ok, config} = ExUnit.CLIFormatter.init(opts)
    {:ok, Map.merge(config, %{failed_tests: [], fallback_count: 0})}
  end

  # Do not count excluded/skipped/invalid tests to provide precise total tests executed (compared to ExUnit.CLIFormatter)
  def handle_cast({:test_finished, %Test{state: {:excluded, _}}}, config = %{trace: false}), do: {:noreply, config}
  def handle_cast({:test_finished, %Test{state: {:skipped, _}}}, config = %{trace: false}), do: {:noreply, config}
  def handle_cast({:test_finished, %Test{state: {:invalid, _}}}, config = %{trace: false}), do: {:noreply, config}

  def handle_cast({:test_finished, test = %Test{state: {:failed, _}}}, config = %{trace: false}) do
    print("[🦑] #{test.name}", :failed, config.colors[:enabled])

    {
      :noreply,
      %{
        config
        | test_counter: update_test_counter(config.test_counter, test),
          failure_counter: config.failure_counter + 1,
          failed_tests: [test | config.failed_tests],
          fallback_count: if(fallback?(test), do: config.fallback_count + 1, else: config.fallback_count)
      }
    }
  end

  def handle_cast({:test_finished, test}, config = %{trace: false}) do
    print("[🐸] #{test.name}", :success, config.colors[:enabled])
    {:noreply, %{config | test_counter: update_test_counter(config.test_counter, test)}}
  end

  def handle_cast(_event = {:suite_finished, run_us, load_us}, config = %{trace: false}) do
    config.failed_tests
    |> Enum.with_index()
    |> Enum.each(&print_failure(&1, config))

    IO.write("\n\n")
    IO.puts(format_time(run_us, load_us))

    report = [
      "#{config.test_counter[:test]}",
      " ",
      "#{pluralize(config.test_counter[:test], "test", "tests")}",
      ?,,
      " ",
      "#{config.failure_counter}",
      " ",
      "#{pluralize(config.failure_counter, "failure", "failures")}"
    ]

    error_digest =
      cond do
        config.fallback_count > 0 and config.fallback_count == config.failure_counter ->
          [
            " ",
            ?(,
            "#{config.fallback_count}",
            " ",
            "#{pluralize(config.failure_counter, "fallback", "fallbacks")}",
            ?)
          ]

        config.fallback_count > 0 ->
          [
            " ",
            ?(,
            "#{config.fallback_count}",
            " ",
            "#{pluralize(config.failure_counter, "fallback", "fallbacks")}",
            ?,,
            " ",
            "#{config.failure_counter - config.fallback_count}",
            " ",
            "#{pluralize(config.failure_counter - config.fallback_count, "other", "others")}",
            ?)
          ]

        true ->
          []
      end

    IO.puts(IO.iodata_to_binary(report ++ error_digest))
    IO.puts("\nRandomized with seed #{config.seed}")

    {:noreply, config}
  end

  defp pluralize(num, singular, _plural) when num in [0, 1], do: singular
  defp pluralize(_, _singular, plural), do: plural

  defdelegate handle_cast(event, config), to: ExUnit.CLIFormatter

  defp update_test_counter(test_counter, %{tags: %{test_type: test_type}}) do
    Map.update(test_counter, test_type, 1, &(&1 + 1))
  end

  defp print(line, :success, true), do: IO.puts(IO.ANSI.green() <> line <> IO.ANSI.reset())
  defp print(line, :failed, true), do: IO.puts(IO.ANSI.red() <> line <> IO.ANSI.reset())
  defp print(line, _outcome, false), do: IO.puts(line)

  defp print_failure({test = %Test{state: {:failed, reason}}, index}, config) do
    IO.puts("")
    IO.puts(format_test_failure(test, reason, index + 1, config.width, &formatter(&1, &2, config)))
  end

  # TODO: format failure / stacktrace with color schemes
  # based on message type :test_info, :location_info,
  # :diff_enabled?, :error_info, stacktrace_info
  defp formatter(_type, msg, _config), do: msg

  defp fallback?(%Test{state: {:failed, failures}}) do
    Enum.reduce_while(failures, false, fn {_kind, reason, _stack}, _state ->
      case fallback?(reason) do
        true -> {:halt, true}
        false -> {:cont, false}
      end
    end)
  end

  defp fallback?(%ExUnit.AssertionError{left: {"belfrage-cache-status", "STALE"}}) do
    true
  end

  defp fallback?(_error), do: false
end
