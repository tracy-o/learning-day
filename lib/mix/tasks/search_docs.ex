defmodule Mix.Tasks.SearchDocs do
  use Mix.Task

  def run([]) do
    get_confluence("smoke+test")
  end

  def get_confluence(my_query) do
    endpoint = "confluence.dev.bbc.co.uk"

    req_path =
      "/dosearchsite.action?cql=siteSearch+~+\"#{my_query}\"+and+space+%3D+\"BELFRAGE\"&queryString=#{my_query}"

    request_route(endpoint, req_path)
  end

  defp request_route(endpoint, path) do
    case HTTPoison.get("https://#{endpoint}#{path}") do
      {:ok, %{status_code: 200, body: body}} ->
        Poison.decode!(body)

      {:ok, %{status_code: 404}} ->
        "returned 404"

      {:error, %{reason: _reason}} ->
        "could not get route"
    end
  end
end
