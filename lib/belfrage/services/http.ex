defmodule Belfrage.Services.HTTP do
  require Logger

  alias Belfrage.Behaviours.Service
  alias Belfrage.{Clients, Struct}
  alias Belfrage.Struct.{Request, Private, Response}
  alias Belfrage.Helpers.QueryParams
  alias Belfrage.Metrics.LatencyMonitor
  alias Belfrage.Mvt
  alias Belfrage.Xray

  @behaviour Service

  @impl Service
  def dispatch(struct = %Struct{private: private = %Private{}}) do
    built_request = build_request(struct)
    struct = LatencyMonitor.checkpoint(struct, :origin_request_sent)
    result = built_request |> execute_request(private)
    struct = LatencyMonitor.checkpoint(struct, :origin_response_received)

    response =
      case result do
        {:ok, response} ->
          track_response(private, response.status_code)
          %Response{http_status: response.status_code, body: response.body, headers: response.headers}

        {:error, %Clients.HTTP.Error{reason: :invalid_request_target}} ->
          %Response{http_status: 404, body: ""}

        {:error, %Clients.HTTP.Error{reason: :invalid_header_value}} ->
          %Response{http_status: 400, body: ""}

        {:error, error} ->
          track_error(struct, error)
          %Response{http_status: 500, body: ""}
      end

    %Struct{struct | response: response}
  end

  defp build_request(struct = %Struct{request: request, private: private}) do
    attrs =
      case request.method do
        "GET" ->
          %{method: :get}

        method ->
          raise "Unsupported method: " <> method
      end

    struct!(
      Clients.HTTP.Request,
      Map.merge(attrs, %{
        url: private.origin <> request.path <> QueryParams.encode(request.query_params),
        headers: build_headers(struct),
        request_id: request.request_id
      })
    )
  end

  defp build_headers(%Struct{request: request, private: private}) do
    edge_headers(request)
    |> Map.merge(default_headers(request))
    |> Map.merge(request.raw_headers)
    |> Map.merge(xray_header(request))
    |> Mvt.Headers.put_mvt_headers(private)
    |> Enum.reject(fn {_k, v} -> is_nil(v) end)
    |> Map.new()
  end

  defp edge_headers(request = %Struct.Request{edge_cache?: true}) do
    %{
      "x-bbc-edge-cache" => "1",
      "x-bbc-edge-country" => request.country,
      "x-bbc-edge-isuk" => is_uk(request.is_uk)
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
      "x-bbc-edge-host" => request.host,
      "x-bbc-edge-scheme" => scheme(request.scheme),
      "x-candy-audience" => request.x_candy_audience,
      "x-candy-override" => request.x_candy_override,
      "x-candy-preview-guid" => request.x_candy_preview_guid,
      "x-morph-env" => request.x_morph_env,
      "x-use-fixture" => request.x_use_fixture,
      "cookie-ckps_language" => request.cookie_ckps_language,
      "cookie-ckps-chinese" => request.cookie_ckps_chinese,
      "cookie-ckps-serbian" => request.cookie_ckps_serbian,
      "origin" => request.origin,
      "referer" =>
        if request.referer do
          URI.encode(request.referer)
        else
          nil
        end,
      "bbc-adverts" => "#{request.is_advertise}",
      "bbc-origin" => bbc_origin(request)
    }
  end

  defp bbc_origin(request) do
    Enum.join([scheme(request.scheme), request.host], "://")
  end

  defp xray_header(%Request{xray_segment: segment = %AwsExRay.Segment{}}) do
    %{"x-amzn-trace-id" => Xray.build_trace_id_header(segment)}
  end

  defp xray_header(_) do
    %{}
  end

  defp scheme(:https), do: "https"
  defp scheme(:http), do: "http"
  defp scheme(_), do: "https"

  defp is_uk(true), do: "yes"
  defp is_uk(false), do: "no"
  defp is_uk(_), do: nil

  defp execute_request(request = %Clients.HTTP.Request{}, private = %Private{}) do
    platform = platform_name(private)

    :telemetry.span([:belfrage, :function, :timing, :service, platform, :request], %{}, fn ->
      {http_impl().execute(request, platform), %{}}
    end)
  end

  defp http_impl() do
    Application.get_env(:belfrage, :http_client, Belfrage.Clients.HTTP)
  end

  defp track_response(private = %Private{}, status) do
    Belfrage.Metrics.multi_execute(
      [
        [:belfrage, :service, platform_name(private), :response, String.to_atom(to_string(status))],
        [:belfrage, :platform, :response]
      ],
      %{count: 1},
      %{platform: platform_name(private), status_code: status}
    )
  end

  defp track_error(struct = %Struct{private: private = %Private{}}, %Clients.HTTP.Error{reason: :timeout}) do
    Belfrage.Metrics.multi_execute(
      [
        [:belfrage, :error, :service, platform_name(private), :timeout],
        [:belfrage, :platform, :response]
      ],
      %{count: 1},
      %{platform: platform_name(private), status_code: "408"}
    )

    log_error(:timeout, struct)
  end

  defp track_error(struct = %Struct{private: private = %Private{}}, error = %Clients.HTTP.Error{}) do
    Belfrage.Metrics.multi_execute(
      [
        [:belfrage, :error, :service, platform_name(private), :request],
        [:belfrage, :error, :service, :request]
      ],
      %{count: 1},
      %{platform: platform_name(private)}
    )

    log_error(error, struct)
  end

  defp platform_name(%Private{platform: platform}) do
    platform |> String.to_atom()
  end

  defp log_error(reason, struct = %Struct{}) do
    Logger.log(:error, "", %{
      msg: "HTTP Service request error",
      reason: reason,
      struct: Struct.loggable(struct)
    })
  end
end
