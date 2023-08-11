defmodule Belfrage.Services.HTTP do
  require Logger

  alias Belfrage.Services.Dispatcher
  alias Belfrage.Behaviours.Service
  alias Belfrage.Envelope
  alias Belfrage.Envelope.Request
  alias Belfrage.Mvt
  alias Belfrage.Xray

  @behaviour Service

  @impl Service
  def dispatch(envelope) do
    Dispatcher.dispatch(envelope, build_headers(envelope))
  end

  defp build_headers(%Envelope{request: request, private: private}) do
    edge_headers(request)
    |> Map.merge(default_headers(request))
    |> Map.merge(request.raw_headers)
    |> Map.merge(xray_header(request))
    |> Mvt.Headers.put_mvt_headers(private)
    |> Enum.reject(fn {_k, v} -> is_nil(v) end)
    |> Map.new()
  end

  defp edge_headers(request = %Envelope.Request{edge_cache?: true}) do
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
end
