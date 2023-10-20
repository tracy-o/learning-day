defmodule SimilarPaths do
  def map_similar_routes(routes, %Conn{request_path: path}) do
    routes
    |> filter_routes()
    |> IO.inspect(label: "did you mean")
    |> Enum.map(fn {matcher, _args} ->
      "<a href=" <> matcher <> ">" <> matcher <> "</a>"
    end)
    |> generate_resp_page()
  end

  defp filter_routes(routes) do
    routes
    |> Enum.filter(fn {matcher, args} ->
      args[:only_on] != "test" and
      !String.contains?(matcher, [":", "*"]) and
      !String.equivalent?(path, matcher) and
      Levenshtein.distance(String.downcase(path), matcher) <= 3
    end)
  end

  defp generate_resp_page(similar_routes) do
    unless Enum.empty?(similar_routes) do
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
