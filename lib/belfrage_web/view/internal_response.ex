defmodule BelfrageWeb.View.InternalResponse do
  alias Belfrage.Struct.Response
  alias Belfrage.Metrics

  @html_content_type "text/html; charset=utf-8"
  @json_content_type "application/json"
  @plain_content_type "text/plain"

  @html_body %{
    # These files are read from disk at compilation time. If you change them be
    # sure to recompile this module.
    404 => File.read!(Application.get_env(:belfrage, :not_found_page)) <> "<!-- Belfrage -->",
    405 => File.read!(Application.get_env(:belfrage, :not_supported_page)) <> "<!-- Belfrage -->",
    500 => File.read!(Application.get_env(:belfrage, :internal_error_page)) <> "<!-- Belfrage -->"
  }

  @redirect_statuses Application.get_env(:belfrage, :redirect_statuses)

  def new(conn, status, cacheable) do
    Metrics.duration(:generate_internal_response, fn ->
      %Response{http_status: status}
      |> put_cache_directive(cacheable)
      |> put_internal_response_headers(conn)
      |> put_body()
    end)
  end

  defp put_cache_directive(response = %Response{http_status: 404}, _cacheable) do
    Map.put(response, :cache_directive, %Belfrage.CacheControl{
      cacheability: "public",
      max_age: 30,
      stale_while_revalidate: 60,
      stale_if_error: 90
    })
  end

  defp put_cache_directive(response = %Response{http_status: http_status}, _cacheable)
       when http_status in @redirect_statuses do
    Map.put(response, :cache_directive, %Belfrage.CacheControl{
      cacheability: "public",
      max_age: 60,
      stale_while_revalidate: 60,
      stale_if_error: 90
    })
  end

  defp put_cache_directive(response, false) do
    Map.put(response, :cache_directive, %Belfrage.CacheControl{
      cacheability: "private",
      max_age: 0,
      stale_while_revalidate: 15
    })
  end

  defp put_cache_directive(response, _cacheable) do
    Map.put(response, :cache_directive, %Belfrage.CacheControl{
      cacheability: "public",
      max_age: 5,
      stale_while_revalidate: 15
    })
  end

  defp put_internal_response_headers(response, conn) do
    Response.add_headers(response, %{
      "content-type" => content_type(conn)
    })
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

  defp put_body(response = %Response{}) do
    body =
      cond do
        response.headers["content-type"] == @json_content_type ->
          ~s({"status":#{response.http_status}})

        response.headers["content-type"] == @plain_content_type ->
          "#{response.http_status}, Belfrage"

        response.http_status in @redirect_statuses ->
          ""

        true ->
          Map.get_lazy(@html_body, response.http_status, fn -> "<h1>#{response.http_status}</h1>\n<!-- Belfrage -->" end)
      end

    %Response{response | body: body}
  end
end
