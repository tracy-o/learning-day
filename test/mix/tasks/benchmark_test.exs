defmodule Mix.Tasks.BenchmarkTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias Mix.Tasks.Benchmark

  test "run/1 executes a suite" do
    assert Benchmark.run(["benchmark_test_suite_mock"]) == "Benchee test results"
  end

  test "run/1 handles not available suite" do
    assert capture_io(fn -> Benchmark.run(["not_available_suite"]) end) == "#{Benchmark.test_not_available_message()}\n"
  end

  test "run/1 only run suites in dev env" do
    assert capture_io(fn -> Benchmark.run([]) end) == "#{Benchmark.test_not_available_message()}\n"
  end

  test "run/2 run all suites" do
    assert Benchmark.run([], "test/support/mocks/benchmark") == :ok
  end
end
