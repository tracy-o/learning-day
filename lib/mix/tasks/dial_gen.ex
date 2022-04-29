defmodule Mix.Tasks.DialGen do
  @moduledoc "Printed when the user requests `mix help echo`"
  @shortdoc "generates dial"

  use Mix.Task
  require EEx

  @impl Mix.Task
  def run(args) do
    with {:ok, dial_name} <- parse_args(args),
         {:ok, valid_dial_name} <- validate(dial_name) do
      generate_dial(valid_dial_name)
    else
      err -> IO.inspect(err)
    end
  end

  defp generate_dial(dial_name) do
    module_name = dial_module_name(dial_name)
    default_description = "I AM A GENERATED DESCRIPTION, CHANGE ME!"
    default_values = [%{"value" => "on", "description" => "this turns me on"}, %{"value" => "off", "description" => "this turns me off"}]
    default_value = "on"

    add_to_cosmos_json(dial_name, default_description, default_value, default_values)
    add_to_dev_env(dial_name, default_value)
    add_to_dial_config(dial_name, module_name)
    generate_dial_module(dial_name, module_name)
    generate_dial_test_module(dial_name, module_name)
  end

  defp add_to_cosmos_json(name, description, default_value, dial_values) do
    with {:ok, raw_json} <- File.read("cosmos/dials.json"),
          {:ok, dials_config} <- Jason.decode(raw_json)
    do
      unless dial_exists?(dials_config, name) do
        new_dial = %{
          "name" => name,
          "description" => description,
          "default-value" => default_value,
          "values" => dial_values
        }

        new_config = dials_config ++ [new_dial]

        new_config_string = Jason.encode!(new_config, pretty: true)

        :ok = File.write("cosmos/dials.json", new_config_string)
      end

    else
      err -> err
    end
  end

  defp add_to_dev_env(name, default_value) do
    with {:ok, raw_json} <- File.read("cosmos/dials_values_dev_env.json"),
      {:ok, dev_values} <- Jason.decode(raw_json) do
        unless dial_exists?(dev_values, name) do
          dev_values_string =
            Map.put(dev_values, name, default_value)
            |> Jason.encode!(pretty: true)

          :ok = File.write("cosmos/dials_values_dev_env.json", dev_values_string)
        end
    end
  end

  defp add_to_dial_config(name, module_name) do
    template_file = "lib/mix/tasks/dial_gen/dial_config_template.eex"
    dials_config_file = "config/dials.exs"

    module = Module.concat([Belfrage,Dials,module_name])

    dial_handlers =
      Application.get_env(:belfrage, :dial_handlers)
      |> Map.put(name, module)

    contents =
      EEx.eval_file(template_file, dial_handlers: inspect(dial_handlers))
      |> Code.format_string!()

    File.write!(dials_config_file, contents)
  end

  defp generate_dial_module(dial_name, module_name) do
    template_file = "lib/mix/tasks/dial_gen/dial_template.eex"
    filename = "lib/belfrage/dials/#{dial_name}.ex"

    contents =
      EEx.eval_file(template_file, module_name: "Belfrage.Dials.#{module_name}")
      |> Code.format_string!()

    File.write!(filename, contents)
  end

  defp generate_dial_test_module(dial_name, module_name) do
    template_file = "lib/mix/tasks/dial_gen/dial_test_tempate.eex"
    filename = "test/belfrage/dials/#{dial_name}_test.exs"

    module_name = "Belfrage.Dials.#{module_name}"
    test_module_name = "#{module_name}Test"

    contents =
      EEx.eval_file(template_file, test_module_name: test_module_name, impl_module_name: module_name)
      |> Code.format_string!()

    File.write!(filename, contents)
  end

  defp parse_args([dial_name]), do: {:ok, dial_name}
  defp parse_args(_), do: {:error, "takes only one argument"}

  defp validate(dial_name) do
    if String.match?(dial_name, ~r/^([[:lower:]]|_)+$/) do
      {:ok, dial_name}
    else
      {:error, "invalid dial name"}
    end
  end

  defp dial_module_name(dial_name) do
    String.split(dial_name, "_")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join()
  end

  defp dial_exists?(dial_config, name) when is_list(dial_config) do
    Enum.any?(dial_config, fn elem -> Map.has_key?(elem, name) end)
  end

  defp dial_exists?(dev_values, name) when is_map(dev_values) do
    Map.has_key?(dev_values, name)
  end
end
