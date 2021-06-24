defmodule Mix.Tasks.Benchmark do
  use Mix.Task

  @dir Application.get_env(:belfrage, :benchmark)[:dir]
  @namespace Application.get_env(:belfrage, :benchmark)[:namespace]

  def run([suite | args]) do
    test_module = Module.concat(@namespace, Macro.camelize(suite))

    case Code.ensure_compiled(test_module) do
      {:module, module} ->
        module.run(args)

      {:error, reason} ->
        IO.puts("Test suite can't be loaded, reason: #{reason}")
    end
  end

  def run([], dir \\ @dir) do
    if dir do
      File.ls!(dir)
      |> Enum.map(&(String.split(&1, ".") |> hd))
      |> Enum.each(&run([&1 | []]))
    else
      IO.puts("Benchmark dir is not configured")
    end
  end
end
