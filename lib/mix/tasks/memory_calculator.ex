defmodule Mix.Tasks.MemoryCalculator do
    @moduledoc """
    Calculate how much RAM to allocate.
    This is based on how much RAM is used and how much is available.
    `mix memory_calculator 2B / 2GiB`
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

    @shortdoc """
    Args should be 2 memory values to compare.
    If no magnitude is defined, the args will be read as bytes by default.

    Examples:
    $ mix memory_calculator 2B 4GiB
    "0.0000000466%"

    $ mix memory_calculator 1 1b
    800%
    """
    def run([a1, a2 | _]) do
      calc_percentage(a1, a2)
      |> IO.inspect()
    end

    def run(_), do: raise "Invalid args"

  defp convert_to_bytes(value) do
    case Integer.parse(value) do
      {num_of_bytes, ""} -> num_of_bytes
      {num, magnitude} -> num * @byte_conversions[magnitude]
      _ -> raise "Invalid argument"
    end
  end

  defp calc_percentage(n1, n2) do
    (convert_to_bytes(n1) / convert_to_bytes(n2) * 100)
    |> :erlang.float_to_binary([{:decimals, 10}, :compact])
    |> Kernel.<>("%")
  end
end
