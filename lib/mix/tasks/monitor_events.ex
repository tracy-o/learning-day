defmodule Mix.Tasks.MonitorEvents do
  use Mix.Task

  def run(_args) do
    Path.wildcard("lib/**/*.ex")
    |> Enum.map(&query_ast/1)
    |> Enum.each(fn finds ->
      case Enum.count(finds) > 1 do
        true ->
          [module_name | occurrences] = Enum.reverse(finds)

          IO.puts IO.ANSI.yellow() <> module_name <> IO.ANSI.reset()
          IO.puts(Enum.join(occurrences, "\n"))
          IO.puts "\n"

        false ->
          :nothing
      end
    end)
  end

  def query_ast(module_file_path) do
    {:ok, ast} = File.read!(module_file_path) |> Code.string_to_quoted()

    acc = [module_name(ast)]

    {_ast, acc} = Macro.postwalk(ast, acc, &find_record_event/2)

    acc
  end

  def find_record_event(v = {{:., _, [{:__aliases__, _, module}, function]}, _, _args}, acc) do
    case event_function_call(module, function) do
      {:ok, :found} ->
        {v, [Macro.to_string(v) | acc]}

      :not_found ->
        {v, acc}
    end
  end

  def find_record_event(v, acc), do: {v, acc}

  defp event_function_call([:Belfrage, :Event], :record) do
    {:ok, :found}
  end

  defp event_function_call(_module, _func), do: :not_found

  defp module_name({:defmodule, _, [{:__aliases__, _, module} | _rest]}) do
    Enum.join(module, ".")
  end

  defp module_name({_keyword, _metadata, children}) do
    module_name(children)
  end

  defp module_name([ast | _rest]) do
    module_name(ast)
  end
end
