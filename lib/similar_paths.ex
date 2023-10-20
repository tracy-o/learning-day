defmodule SimilarPaths do
  defp did_you_mean(routes, %Conn{request_path: path}) do
    similar =
      routes
      |> Enum.filter(fn {matcher, args} ->
        args[:only_on] != "test" and
        !String.contains?(matcher, [":", "*"]) and
        !String.equivalent?(path, matcher) and
        Levenshtein.distance(String.downcase(path), matcher) <= 3
      end)
      |> IO.inspect(label: "did you mean")
      |> Enum.map(fn {matcher, _args} ->
        "<a href=" <> matcher <> ">" <> matcher <> "</a>"
      end)

    unless Enum.empty?(similar) do
      """
      <h1>404 Page Not Found</h1>\n<!-- Belfrage -->
      <p>Did you mean...
      <ul>#{for route <- similar, do: "<li>" <> route <> "</li>"}</ul>
      </p>
      """
    else
      ""
    end
  end
end
