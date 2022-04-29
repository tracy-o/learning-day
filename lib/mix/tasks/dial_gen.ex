defmodule Mix.Tasks.DialGen do
  @moduledoc "Printed when the user requests `mix help echo`"
  @shortdoc "generates dial"

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    parse(args)
  end


  defp parse(args) do
    [dial_name | _rest] = args

    {dial_name, dial_module_name} = parse_dial_name(dial_name)
    add_to_cosmos_json("jeff", "a_desc", "on", [%{"value" => "on", "description" => "this turns me on"}, %{"value" => "off", "description" => "this turns me off"}])
    add_to_dev_env("jeff", "on")
    add_to_dial_config("jeff", Belfrage.Dials.Jeff)
  end

  defp parse_dial_name(arg) do
    lower_alpha = ((for n <- ?a..?z, do: n) |> to_string()) <> "_"

    parsed_dial = String.graphemes(arg)
    |> Enum.reduce_while(
      [],fn x, acc ->
        if String.contains?(lower_alpha, x) do
          {:cont, [x| acc]}
        else
          {:halt, {:error, "invalid char '#{x}' in dial name"}}
        end
      end
    )

    case parsed_dial do
      {:error, reason} ->
        {:error, reason}

      dial ->
        parsed_dial = dial
        |> Enum.reverse()
        |> Enum.join()

        {parsed_dial, dial_module_name(parsed_dial)}
    end
  end

  def dial_module_name(dial_name) do
    String.graphemes(dial_name)
    |> Enum.reduce(
      [],
      fn x, acc ->
        case acc do
          [] -> [String.upcase(x)]
          ["_"| rest] -> [String.upcase(x)| rest]
          [_| _rest] -> [x| acc]

        end
      end
    )
    |> Enum.reverse()
    |> Enum.join()
    |> String.trim_trailing("_")
  end

  def add_to_dev_env(name, default_value) do
    with {:ok, raw_json} <- File.read("cosmos/dials_values_dev_env.json"),
      {:ok, dev_values} <- Jason.decode(raw_json) do
        {:ok, dev_values_string} = Map.put(dev_values, name, default_value)
        |> Jason.encode(pretty: true)

        :ok = File.write("cosmos/dials_values_dev_env.json", dev_values_string)
    end
  end

  def add_to_cosmos_json(name, description, default_value, dial_values) do
    with {:ok, raw_json} <- File.read("cosmos/dials.json"),
          {:ok, dials_config} <- Jason.decode(raw_json)
    do
      new_dial = %{
        "name" => name,
        "description" => description,
        "default-value" => default_value,
        "values" => dial_values
      }

      new_config = dials_config ++ [new_dial]

      {:ok, new_config_string} = Jason.encode(new_config, pretty: true)

      :ok = File.write("cosmos/dials.json", new_config_string)
    else
      err -> err
    end
  end

  def add_to_dial_config(name, module_name) do
    require EEx

    template_file = "lib/mix/tasks/dial_gen/dial_config.eex"
    dials_config_file = "config/dials.exs"

    dial_handlers =
      Application.get_env(:belfrage, :dial_handlers)
      |> Map.put(name, module_name)

    contents =
      EEx.eval_file(template_file, dial_handlers: inspect(dial_handlers))
      |> Code.format_string!()

    File.write!(dials_config_file, contents)
  end
end
