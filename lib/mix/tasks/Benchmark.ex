defmodule Mix.Tasks.Benchmark do
  use Mix.Task

  @dir Application.get_env(:belfrage, :benchmark)[:dir]
  @namespace Application.get_env(:belfrage, :benchmark)[:namespace]

  def run([suite | args]) do
    test_module = Module.concat(@namespace, Macro.camelize(suite))

    test_module
    |> Code.ensure_compiled?()
    |> run({test_module, args})
  end

  def run([]), do: run([], @dir)

  def run([], dir) when dir != nil do
    File.ls!(dir)
    |> Enum.map(&(String.split(&1, ".") |> hd))
    |> Enum.each(&run([&1 | []]))
  end

  def run([], _), do: IO.puts(test_not_available_message())

  def run(false, _), do: IO.puts(test_not_available_message())

  def run(true, {module, args}) do
    module.run(args)
  end

  def test_not_available_message(), do: "Test suite not available"
end
