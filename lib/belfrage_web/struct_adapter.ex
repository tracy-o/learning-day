defmodule BelfrageWeb.StructAdapter do
  alias Belfrage.Struct
  alias Belfrage.Struct.{Request, Private}
  alias Plug.Conn
  import Plug.Conn

  def adapt(conn = %Conn{private: %{xray_trace_id: xray_trace_id, bbc_headers: bbc_headers}}, loop_id) do
    Stump.metadata(loop_id: loop_id)

    %Struct{
      request: %Request{
        path: conn.request_path,
        payload: body(conn),
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
        xray_trace_id: xray_trace_id,
        accept_encoding: accept_encoding(conn),
        is_uk: bbc_headers.is_uk,
        is_advertise: bbc_headers.is_advertise,
        req_svc_chain: bbc_headers.req_svc_chain,
        request_id: conn.private.request_id,
        x_cdn: bbc_headers.x_cdn,
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
        user_agent: bbc_headers.user_agent
      },
      private: %Private{
        loop_id: loop_id,
        overrides: conn.private.overrides,
        production_environment: conn.private.production_environment,
        preview_mode: conn.private.preview_mode,
        personalisation: personalisation_enabled?(loop_id)
      }
    }
  end

  defp body(conn) do
    case read_body(conn) do
      {:ok, body, _conn} -> body
      _ -> nil
    end
  end

  defp raw_headers(conn), do: Enum.into(conn.req_headers, %{})

  defp subdomain(%Plug.Conn{host: host}) when bit_size(host) > 0 do
    host
    |> String.split(".")
    |> List.first()
  end

  defp subdomain(_conn), do: "www"

  defp accept_encoding(conn) do
    case Plug.Conn.get_req_header(conn, "accept-encoding") do
      [accept_encoding] -> accept_encoding
      [] -> nil
    end
  end

  # For now, personalisation is not supported for cascade routes
  defp personalisation_enabled?(loop_id) do
    if loop_id == "redirect" || is_list(loop_id) do
      false
    else
      Belfrage.EnablePersonalisation.personalisation_enabled?(loop_id)
    end
  end
end
