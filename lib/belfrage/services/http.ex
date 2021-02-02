defmodule Belfrage.Services.HTTP do
  require Belfrage.Event

  alias Belfrage.Behaviours.Service
  alias Belfrage.{Clients, Struct}
  alias Belfrage.Helpers.QueryParams

  @http_client Application.get_env(:belfrage, :http_client, Clients.HTTP)

  @behaviour Service

  @impl Service
  def dispatch(struct = %Struct{}) do
    platform = Macro.to_string(struct.private.platform)

    Belfrage.Event.record "function.timing.service.#{platform}.request" do
      struct
      |> execute_request()
      |> handle_response()
    end
  end

  defp handle_response({{:ok, %Clients.HTTP.Response{status_code: status, body: body, headers: headers}}, struct}) do
    platform = Macro.to_string(struct.private.platform)
    Belfrage.Event.record(:metric, :increment, "service.#{platform}.response.#{status}")
    Map.put(struct, :response, %Struct.Response{http_status: status, body: body, headers: headers})
  end

  defp handle_response({{:error, %Clients.HTTP.Error{reason: :timeout}}, struct}) do
    platform = Macro.to_string(struct.private.platform)
    Belfrage.Event.record(:metric, :increment, "error.service.#{platform}.timeout")
    log(:timeout, struct)
    Struct.add(struct, :response, %Struct.Response{http_status: 500, body: ""})
  end

  defp handle_response({{:error, error}, struct}) do
    platform = Macro.to_string(struct.private.platform)
    Belfrage.Event.record(:metric, :increment, "error.service.#{platform}.request")
    log(error, struct)
    Struct.add(struct, :response, %Struct.Response{http_status: 500, body: ""})
  end

  defp log(reason, struct) do
    Belfrage.Event.record(:log, :error, %{
      msg: "HTTP Service request error",
      reason: reason,
      struct: Struct.loggable(struct)
    })
  end

  defp execute_request(struct = %Struct{request: request = %Struct.Request{method: "POST"}, private: private}) do
    {@http_client.execute(%Clients.HTTP.Request{
       method: :post,
       url: private.origin <> request.path <> QueryParams.encode(request.query_params),
       payload: request.payload,
       headers: build_headers(request)
     }), struct}
  end

  defp execute_request(struct = %Struct{request: request = %Struct.Request{method: "GET"}, private: private}) do
    {@http_client.execute(%Clients.HTTP.Request{
       method: :get,
       url: private.origin <> request.path <> QueryParams.encode(request.query_params),
       headers: build_headers(request)
     }), struct}
  end

  defp build_headers(request) do
    edge_headers(request)
    |> Map.merge(default_headers(request))
    |> Map.merge(request.raw_headers)
    |> Enum.reject(fn {_k, v} -> is_nil(v) end)
    |> Map.new()
  end

  defp edge_headers(request = %Struct.Request{edge_cache?: true}) do
    %{
      "x-bbc-edge-cache" => "1",
      "x-bbc-edge-country" => request.country,
      "x-bbc-edge-host" => request.host,
      "x-bbc-edge-isuk" => is_uk(request.is_uk),
      "x-bbc-edge-scheme" => scheme(request.scheme)
    }
  end

  defp edge_headers(request) do
    %{
      "x-country" => request.country,
      "x-forwarded-host" => request.host,
      "x-ip_is_uk_combined" => is_uk(request.is_uk),
      "x-ip_is_advertise_combined" => is_uk(request.is_advertise)
    }
  end

  defp default_headers(request) do
    %{
      "accept-encoding" => "gzip",
      "user-agent" => "Belfrage",
      "req-svc-chain" => request.req_svc_chain,
      "x-cdn" => request.x_cdn,
      "x-candy-audience" => request.x_candy_audience,
      "x-candy-override" => request.x_candy_override,
      "x-candy-preview-guid" => request.x_candy_preview_guid,
      "x-morph-env" => request.x_morph_env,
      "x-use-fixture" => request.x_use_fixture,
      "cookie-cps-language" => request.cookie_cps_language,
      "cookie-cps-chinese" => request.cookie_cps_chinese,
      "cookie-cps-serbian" => request.cookie_cps_serbian
    }
  end

  defp scheme(:https), do: "https"
  defp scheme(:http), do: "http"

  defp is_uk(true), do: "yes"
  defp is_uk(_), do: nil
end
