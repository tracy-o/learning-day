defmodule SimilarPaths do
  alias Plug.Conn

  def map_similar_routes(routes, %Conn{request_path: req_path}) do
    routes
    |> filter_routes(req_path)
    |> IO.inspect(label: "did you mean")
    |> Enum.map(fn {matcher, _args} ->
      "<a href=" <> matcher <> ">" <> matcher <> "</a>"
    end)
    |> generate_resp_page()
  end

  defp filter_routes(routes, path) do
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
      <ul>#{for route <- similar_routes, do: "<li>" <> route <> "</li>"}</ul>
      </p>
      """
    else
      ""
    end
  end
end
