defmodule Mix.Tasks.MonitorEvents do
  use Mix.Task
  def run(_args) do
    Path.wildcard("lib/**/*.ex")
    |> Enum.each(&query_ast/1)
  end

  def query_ast(module_file_path) do
    {:ok, ast} = File.read!(module_file_path) |> Code.string_to_quoted()

    Macro.postwalk(ast, &find_record_event/1)
  end

  def find_record_event(v = {{:., _, [{:__aliases__, _, module}, function]}, _, _args}) do
    case event_function_call(module, function) do
      {:ok, :found} ->
        IO.puts Macro.to_string(v)
        IO.puts "\n"
        v

      :not_found -> v
    end
  end

  def find_record_event(v), do: v

  defp event_function_call([:Belfrage, :Event], :record) do
    {:ok, :found}
  end

  defp event_function_call(_module, _func), do: :not_found
end
