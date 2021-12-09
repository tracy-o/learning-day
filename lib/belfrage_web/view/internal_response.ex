defmodule BelfrageWeb.View.InternalResponse do
  alias Belfrage.Struct.Response
  alias Belfrage.{Metrics, CacheControl}
  alias Plug.Conn

  @redirect_statuses Application.get_env(:belfrage, :redirect_statuses)

  @html_body Map.new(
               Enum.map(@redirect_statuses, fn status -> {status, ""} end) ++
                 [
                   # These files are read from disk at compilation time. If you change them be
                   # sure to recompile this module.
                   {404, File.read!(Application.get_env(:belfrage, :not_found_page)) <> "<!-- Belfrage -->"},
                   {405, File.read!(Application.get_env(:belfrage, :not_supported_page)) <> "<!-- Belfrage -->"},
                   {500, File.read!(Application.get_env(:belfrage, :internal_error_page)) <> "<!-- Belfrage -->"}
                 ]
             )

  def new(conn, status, cacheable) do
    Metrics.duration(:generate_internal_response, fn ->
      response = %Response{http_status: status}
      {content_type, body} = body(status, conn)

      %Response{
        response
        | headers: %{"content-type" => content_type},
          body: body,
          cache_directive: cache_control(status, cacheable)
      }
    end)
  end

  defp body(status, conn = %Conn{}) do
    accepted_content_type = Conn.get_req_header(conn, "accept") |> List.first()

    cond do
      accepted_content_type == nil || String.contains?(accepted_content_type, "html") ->
        body = Map.get_lazy(@html_body, status, fn -> "<h1>#{status}</h1>\n<!-- Belfrage -->" end)

        {"text/html; charset=utf-8", body}

      String.contains?(accepted_content_type, "json") ->
        {"application/json", ~s({"status":#{status}})}

      true ->
        {"text/plain", "#{status}, Belfrage"}
    end
  end

  defp cache_control(status, cacheable) do
    cond do
      status == 404 ->
        %CacheControl{
          cacheability: "public",
          max_age: 30,
          stale_while_revalidate: 60,
          stale_if_error: 90
        }

      status in @redirect_statuses ->
        %CacheControl{
          cacheability: "public",
          max_age: 60,
          stale_while_revalidate: 60,
          stale_if_error: 90
        }

      cacheable ->
        %CacheControl{
          cacheability: "public",
          max_age: 5,
          stale_while_revalidate: 15
        }

      true ->
        %CacheControl{
          cacheability: "private",
          max_age: 0,
          stale_while_revalidate: 15
        }
    end
  end
end
