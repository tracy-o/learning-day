defmodule Mix.Tasks.MemoryCalculator do
  @moduledoc """
  Calculate how much RAM to allocate.
  This is based on how much RAM is used and how much is available.

  Input values are read as Bytes (B) by default.
  Specify another memory size by appending to the value.
  I.e.
  > 3 kilobytes = 3kB
  > 4 Gibibytes = 4GiB
  > 8 bits = 8b
  """

  @shortdoc """
  Memory calculator to compare memory values.
  """

  use Mix.Task

  # https://ozanerhansha.medium.com/kilobytes-vs-kibibytes-d77eb2ff6c2a
  @byte_conversions %{
    "B" => 1,
    "b" => 0.125,
    "kB" => 1_000,
    "kiB" => 1_024,
    "MB" => 1_000_000,
    "MiB" => 1_048_576,
    "GB" => 1_000_000_000,
    "GiB" => 1_073_741_824,
    "TB" => 1_000_000_000_000,
    "TiB" => 1_099_511_627_776
  }

  # entries = max memory available
  @custom_opts %{
    strict_rules: [{:entries, :string}, {:percent, :string}],
    aliases: [e: :entries, p: :percent]
  }

  @doc """
  Args should be a mode paired with a maxium memory value to compare.
  Memory value args will be read as bytes by default.

  Examples:
  $ mix memory_calculator --percent 2B 4GiB
    average size of entry > 2B
    "0.0000000466%"

  $ mix memory_calculator -p 1b
    average size of entry > 1
    "800.0%"

  $ mix memory_calculator --entries 32GiB
    memory (%) to allocate > 0.2
    average size of entry > 40
    1717986.9184
  """
  @impl Mix.Task
  def run(args) do
    {parsed_args, _, _} =
      OptionParser.parse(args, aliases: @custom_opts.aliases, strict: @custom_opts.strict_rules)

    parse_args(parsed_args)
  end

  defp parse_args([{:entries, max_memory}]) do
    {percent, _} = user_input("memory (%) to allocate > ") |> Float.parse()
    entry_size = user_input("average size of entry > ") |> convert_to_bytes()

    calculate_entries(entry_size, percent, convert_to_bytes(max_memory))
    |> IO.inspect()
  end

  defp parse_args([{:percent, max_memory}]) do
    available_memory = user_input("average size of entry > ") |> convert_to_bytes()

    calculate_percentage(available_memory, convert_to_bytes(max_memory))
    |> IO.inspect()
  end

  defp parse_args(_args) do
    raise("Invalid args. Please choose either --entries <max_memory> or --percent <max_memory>")
  end

  defp user_input(prompt) do
    prompt
    |> IO.gets()
    |> String.trim()
  end

  def convert_to_bytes(value) do
    case Float.parse(value) do
      {num_of_bytes, ""} -> num_of_bytes
      {num, val} -> num * @byte_conversions[val]
      _ -> raise "Invalid argument"
    end
  end

  defp calculate_entries(entry_size, percentage, max_memory) do
    available_memory = max_memory * (percentage / 100)
    available_memory / entry_size
  end

  defp calculate_percentage(n1, n2) do
    (n1 / n2 * 100)
    |> :erlang.float_to_binary([{:decimals, 10}, :compact])
    |> Kernel.<>("%")
  end
end
