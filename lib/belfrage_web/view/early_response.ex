defmodule BelfrageWeb.View.EarlyResponse do
  @file_io Application.get_env(:belfrage, :file_io)
  alias Belfrage.Struct.Response

  @html_content_type "text/html; charset=utf-8"
  @json_content_type "application/json"
  @plain_content_type "text/plain"

  def new(conn, status) do
    %Response{http_status: status}
    |> put_cache_directive()
    |> put_resp_content_type(conn)
    |> put_body()
  end

  defp put_cache_directive(response = %Response{http_status: 404}) do
    Map.put(response, :cache_directive, %{cacheability: "private", max_age: 0, stale_if_error: 0, stale_while_revalidate: 0})
  end

  defp put_cache_directive(response) do
    Map.put(response, :cache_directive, %{cacheability: "private", max_age: 0, stale_if_error: 0, stale_while_revalidate: 0})
  end

  defp put_resp_content_type(response, conn) do
    Response.add_headers(response, %{"content-type" => content_type(conn)})
  end

  defp content_type(conn) do
    accept = accept_content_type(conn)
    cond do
      String.contains?(accept, "html") -> @html_content_type
      String.contains?(accept, "json") -> @json_content_type
      true -> @plain_content_type
    end
  end

  defp accept_content_type(conn) do
    case Plug.Conn.get_req_header(conn, "accept") do
      [accept] -> accept
      [] -> @html_content_type
    end
  end

  defp put_body(response = %Response{headers: %{"content-type" => @json_content_type}}) do
    Map.put(response, :body, ~s({"status":#{response.http_status}}))
  end

  defp put_body(response = %Response{headers: %{"content-type" => @plain_content_type}}) do
    Map.put(response, :body, "#{response.http_status}, Belfrage")
  end

  defp put_body(response = %Response{headers: %{"content-type" => @html_content_type}}) do
    Map.put(response, :body, error_body(response.http_status))
  end

  defp error_body(404), do: error_body(Application.get_env(:belfrage, :not_found_page), 404)
  defp error_body(405), do: error_body(Application.get_env(:belfrage, :not_supported_page), 405)
  defp error_body(500), do: error_body(Application.get_env(:belfrage, :internal_error_page), 500)
  defp error_body(status_code), do: default_error_body(status_code)

  defp error_body(path, status) do
    case @file_io.read(path) do
      {:ok, body} -> body <> "<!-- Belfrage -->"
      {:error, _} -> default_error_body(status)
    end
  end

  defp default_error_body(500), do: "<h1>500 Internal Server Error</h1>\n<!-- Belfrage -->"
  defp default_error_body(404), do: "<h1>404 Page Not Found</h1>\n<!-- Belfrage -->"
  defp default_error_body(http_status), do: "<h1>#{http_status}</h1>\n<!-- Belfrage -->"
end
