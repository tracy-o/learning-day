defmodule BelfrageWeb.StructAdapter.Request do
  alias Belfrage.Struct
  alias Plug.Conn

  def adapt(conn = %Conn{private: %{bbc_headers: bbc_headers}}) do
    %Struct{
      request: %Struct.Request{
        path: conn.request_path,
        raw_headers: raw_headers(conn),
        method: conn.method,
        country: bbc_headers.country,
        path_params: conn.path_params,
        query_params: conn.query_params,
        scheme: bbc_headers.scheme,
        host: bbc_headers.host || conn.host,
        has_been_replayed?: bbc_headers.replayed_traffic,
        origin_simulator?: bbc_headers.origin_simulator,
        subdomain: subdomain(conn),
        edge_cache?: bbc_headers.cache,
        cdn?: bbc_headers.cdn,
        xray_segment: conn.assigns[:xray_segment],
        accept_encoding: accept_encoding(conn),
        is_uk: bbc_headers.is_uk,
        is_advertise: bbc_headers.is_advertise,
        req_svc_chain: bbc_headers.req_svc_chain,
        request_id: conn.private.request_id,
        x_candy_audience: bbc_headers.x_candy_audience,
        x_candy_override: bbc_headers.x_candy_override,
        x_candy_preview_guid: bbc_headers.x_candy_preview_guid,
        x_morph_env: bbc_headers.x_morph_env,
        x_use_fixture: bbc_headers.x_use_fixture,
        cookie_ckps_language: bbc_headers.cookie_ckps_language,
        cookie_ckps_chinese: bbc_headers.cookie_ckps_chinese,
        cookie_ckps_serbian: bbc_headers.cookie_ckps_serbian,
        origin: bbc_headers.origin,
        referer: bbc_headers.referer,
        user_agent: bbc_headers.user_agent,
        app?: app?(conn)
      }
    }
  end

  defp raw_headers(conn), do: Enum.into(conn.req_headers, %{})

  defp subdomain(%Conn{host: host}) when bit_size(host) > 0 do
    host
    |> String.split(".")
    |> List.first()
  end

  defp subdomain(_conn), do: "www"

  defp accept_encoding(conn) do
    case Conn.get_req_header(conn, "accept-encoding") do
      [accept_encoding] -> accept_encoding
      [] -> nil
    end
  end

  defp app?(conn) do
    conn
    |> subdomain()
    |> String.contains?("app")
  end
end
