defmodule Belfrage.SmokeTestDiff do
  @outputs %{"www" => "www_output.txt", "named" => "stack_output.txt"}
  @compare_to System.get_env("WITH_DIFF")

  def build(matcher_path, env, response) do
    if @compare_to, do: write_data(matcher_path, env, response)
  end

  defp write_data(path, env, %Finch.Response{headers: headers}) do
    resp_headers =
      headers
      |> Enum.into(%{})
      |> Map.drop(["date", "brequestid", "bsig"])

    case resp_headers["bid"] do
      "www" -> generate_output(inspect({env, path,  Map.delete(resp_headers, "bid")}, limit: :infinity))
      @compare_to -> generate_output(inspect({env, path,  Map.delete(resp_headers, "bid")}, limit: :infinity), "named")
      _ -> nil
    end
  end

  defp generate_output(content, bid \\ "www") do
    {:ok, output} = File.open(@outputs[bid], [:append])
    IO.puts(output, content)
    File.close(output)
  end

  def sort_files() do
    for {_, output} <- @outputs do
      {:ok, data} = File.read(output)
      content = data |> String.split("\n") |> Enum.uniq() |> Enum.sort() |> Enum.join("\n")
      File.write(output, content)
    end
  end

  def get_route_diff() do
    {:ok, stack_data} = File.read(@outputs["named"])
    {:ok, www_data} = File.read(@outputs["www"])

    output =
      stack_data
      |> String.split("\n")
      |> Enum.filter(fn l -> l != "" end)
      |> Enum.map(fn line ->
        [_, path, _] = String.split(line, ", ", parts: 3)
        path = String.replace(path, "\"", "")

        case Enum.find(String.split(www_data, "\n"), fn l -> l =~ line end) do
          nil ->
            "Route not found on WWW: " <> path <> "\n"
          www_line ->
            "Approximately #{String.bag_distance(line, www_line) * 100}% similarity to WWW for route: " <> path <> "\n"
        end
      end)

    File.write("smoke_test_diff.txt", output)
  end
end
