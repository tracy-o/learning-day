defmodule Belfrage.Services.HTTP do
  require Logger
  require Belfrage.Event

  alias Belfrage.Behaviours.Service
  alias Belfrage.{Clients, Struct}
  alias Belfrage.Struct.{Request, Private, Response}
  alias Belfrage.Helpers.QueryParams
  alias Belfrage.Metrics.LatencyMonitor
  alias Belfrage.Xray

  @behaviour Service

  @impl Service
  def dispatch(struct = %Struct{request: request = %Request{}, private: private = %Private{}}) do
    built_request = request |> build_request(private.origin)
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

  defp build_request(request = %Request{}, origin) do
    attrs =
      case request.method do
        "GET" ->
          %{method: :get}

        "POST" ->
          %{method: :post, payload: request.payload}

        method ->
          raise "Unsupported method: " <> method
      end

    struct!(
      Clients.HTTP.Request,
      Map.merge(attrs, %{
        url: origin <> request.path <> QueryParams.encode(request.query_params),
        headers: build_headers(request),
        request_id: request.request_id
      })
    )
  end

  defp build_headers(request) do
    edge_headers(request)
    |> Map.merge(default_headers(request))
    |> Map.merge(request.raw_headers)
    |> Map.merge(xray_header(request))
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
      # "x-candy-audience" => request.x_candy_audience,
      # "x-candy-override" => request.x_candy_override,
      # "x-candy-preview-guid" => request.x_candy_preview_guid,
      # "x-morph-env" => request.x_morph_env,
      # "x-use-fixture" => request.x_use_fixture,
      # "cookie-ckps_language" => request.cookie_ckps_language,
      # "cookie-ckps-chinese" => request.cookie_ckps_chinese,
      # "cookie-ckps-serbian" => request.cookie_ckps_serbian,
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

    Belfrage.Event.record "function.timing.service.#{platform}.request" do
      http_impl().execute(request, platform)
    end
  end

  defp http_impl() do
    Application.get_env(:belfrage, :http_client, Belfrage.Clients.HTTP)
  end

  defp track_response(private = %Private{}, status) do
    Belfrage.Event.record(:metric, :increment, "service.#{platform_name(private)}.response.#{status}")
  end

  defp track_error(struct = %Struct{private: private = %Private{}}, %Clients.HTTP.Error{reason: :timeout}) do
    Belfrage.Event.record(:metric, :increment, "error.service.#{platform_name(private)}.timeout")
    log_error(:timeout, struct)
  end

  defp track_error(struct = %Struct{private: private = %Private{}}, error = %Clients.HTTP.Error{}) do
    Belfrage.Event.record(:metric, :increment, "error.service.#{platform_name(private)}.request")
    log_error(error, struct)
  end

  defp platform_name(%Private{platform: platform}) do
    Module.split(platform) |> hd() |> String.to_atom()
  end

  defp log_error(reason, struct = %Struct{}) do
    Logger.log(:error, "", %{
      msg: "HTTP Service request error",
      reason: reason,
      struct: Struct.loggable(struct)
    })
  end
end
