defmodule Mix.Tasks.DialGen do
  @moduledoc "Printed when the user requests `mix help echo`"
  @shortdoc "Echoes arguments"

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    parse(args)
  end


  defp parse(args) do
    [dial_name | _rest] = args

    parse_dial_name(dial_name)
  end

  defp parse_dial_name(arg) do
    lower_alpha = for n <- ?a..?z, do: n
    IO.inspect(lower_alpha)

    parsed_dial = String.graphemes(arg)
    |> Enum.reduce_while(
      [],fn x, acc ->
        if String.contains?(x, lower_alpha) do
          {:cont, [x| acc]}
        else
          {:halt, {:error, "invalid dial name"}}
        end
      end
    )
    |> Enum.reverse()
    |> Enum.join()

    case parsed_dial do
      {:error, reason} -> {:error, reason}
      parsed_dial -> {parsed_dial, dial_module_name(parsed_dial)}
    end
  end

  def dial_module_name(dial_name) do
    String.graphemes(dial_name)
    |> Enum.reduce(
      fn x, acc ->
        [prev_1 | rest] = acc
        case prev_1 do
          '_' -> [String.upcase(x)| rest]
          _ -> [x| acc]
        end
      end
    )
    |> Enum.reverse()
    |> Enum.join()
  end
end
