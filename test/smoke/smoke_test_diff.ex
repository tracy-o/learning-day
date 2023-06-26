defmodule Belfrage.SmokeTestDiff do
  @outputs %{"www" => "www_output.txt", "named" => "stack_output.txt"}
  @compare_to System.get_env("WITH_DIFF")

  def build(matcher_path, env, response) do
    case @compare_to do
      nil -> nil
      _ -> write_data(matcher_path, env, response)
    end
  end

  defp write_data(path, env, %Finch.Response{headers: headers}) do
    resp_headers =
      headers
      |> Enum.into(%{})
      |> Map.drop(["vary", "date", "brequestid", "bsig"])

    case resp_headers["bid"] do
      "www" -> generate_output(inspect({env, path, resp_headers}, limit: :infinity))
      @compare_to -> generate_output(inspect({env, path, resp_headers}, limit: :infinity), "named")
      _ -> nil
    end
  end

  defp generate_output(content, bid \\ "www") do
    {:ok, output} = File.open(@outputs[bid], [:append])
    IO.puts(output, content)
    File.close(output)
  end

  def sort_files() do
    for {_, path} <- @outputs do
      {:ok, data} = File.read(path)

      new_data =
        data
        |> String.split("\n")
        |> Enum.sort()
        |> Enum.join("\n")

      {:ok, io_device} = File.open(path, [:write])
      IO.write(io_device, new_data)
    end
  end
end
