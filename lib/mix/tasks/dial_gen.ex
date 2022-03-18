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
    # add_to_config("jeff", "Jeff")
    add_to_belfrage_config("jeff", Jeff)
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


  # def add_to_config(name, module_name) do
  #   with {:ok, source_code} <- File.read("config/config.exs"),
  #     {:ok, config_ast} <- Code.string_to_quoted(source_code) do
  #       IO.inspect(get_dial_handlers(config_ast))

  #   end

    # dial_handlers = Application.get_env(:belfrage, :dial_handlers)
    # full_module_name = String.to_atom("Belfrage.Dials.#{module_name}")
    # dial_handlers = Map.put(dial_handlers, name, full_module_name)
    # Application.put_env(:belfrage, :dial_handlers, dial_handlers)
  # end

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

  def add_to_belfrage_config(name, module_name) do
    with {:ok, config_string} <- File.read("config/config.exs"),
          {:ok, config_ast} <- Code.string_to_quoted(config_string) do

        source_string =
          gen_new_config_ast(config_ast, "jeff", Jeff)
          |> Macro.to_string()
          |> Code.format_string!()

        File.write!("config/config.exs", source_string)
    end
  end

  def gen_new_config_ast(config_ast, name, module_name) do
    belfrage_opts = get_belfrage_opts(config_ast)
    {statements, removed_index} = remove_belfrage_opts(config_ast)
    # IO.inspect({statements, removed_index})
    dial_handler_ast = Keyword.get(belfrage_opts, :dial_handlers)
    dial_handler_ast = build_dial_handler("jeff", Jeff) |> add_dial_to_handlers(dial_handler_ast)
    belfrage_opts = Keyword.put(belfrage_opts, :dial_handlers, dial_handler_ast)
    belfrage_statement = build_belfrage_config(belfrage_opts)
    statements = insert_statement(statements, removed_index, belfrage_statement)

    {:__block__, [], statements}
  end

  def get_belfrage_opts(config_ast) do
    {_block, _meta, statments} = config_ast

    statments
    |> Enum.filter(fn {func, _meta, _args} -> func == :config end)
    |> Enum.map(fn {_config_func, _meta, statments} -> statments end)
    |> Enum.filter(fn [arg1| _rest] -> arg1 == :belfrage end)
    |> Enum.map(fn [_belfrage_arg| opts] -> opts end)
    |> case do
      [[opts]] -> opts
    end
  end

  def remove_belfrage_opts(config_ast) do
    {_block, _meta, statments} = config_ast

    {statments, index_removed} =
      statments
      |> Enum.with_index()
      |> Enum.reduce({[], -1}, fn {statement, i}, {list_acc, index_removed} ->
          case statement do
            {:config, _meta, [:belfrage, _a_list]} -> {list_acc, i}
            s -> {[s| list_acc], index_removed}
          end
        end
      )

    {Enum.reverse(statments), index_removed}
  end

  def insert_statement(statments, index, new_statment) do
    List.insert_at(statments,index, new_statment)
  end

  def find_and_replace_belfrage_config(statment, new_statment) do
    with {:config, _, child_statments} <- statment,
      {:belfrage, _, _opts} <- child_statments do
        new_statment
    else
      _err -> statment
    end
  end


  def build_belfrage_config(opts) do
    {:config, [], [:belfrage, opts]}
  end

  def add_handlers_to_opts(dial_handlers, opts) do
    Keyword.put(opts, :dial_handlers, dial_handlers)
  end

  def add_dial_to_handlers(new_dial_handler_ast, dial_handlers_ast) do
    {:%{}, _meta, handlers} = dial_handlers_ast
    {:%{}, [], [new_dial_handler_ast| handlers]}
  end

  def build_dial_handler(name, module_name) do
    {name, {:__aliases__, [], [Belfrage, :Dials, module_name]}}
  end
end
