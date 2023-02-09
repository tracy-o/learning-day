defmodule Belfrage.RequestTransformers.WeatherLanguageCookie do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Utils

  @redirect_languages ["en", "cy", "ga", "gd"]
  @one_year_in_seconds 365 * 24 * 3600

  def call(envelope) do
    language = envelope.request.path_params["language"]
    redirect_location = envelope.request.query_params["redirect_location"] || "/weather"

    cond do
      not BelfrageWeb.Validators.matches?(redirect_location, ~r/^[\/]/) ->
        {:stop, update_resp_envelope(envelope, 404, %{})}

      language not in @redirect_languages ->
        {:stop, update_resp_envelope(envelope, 404, %{})}

      true ->
        headers = %{
          "location" => redirect_url(envelope.request.host, redirect_location),
          "set-cookie" =>
            "ckps_language=#{language}; expires=#{next_year_http_date()}; path=/; domain=#{request_domain(envelope.request.host)}",
          "cache-control" => "public, stale-if-error=90, stale-while-revalidate=30, max-age=60"
        }

        {:stop, update_resp_envelope(envelope, 301, headers)}
    end
  end

  defp update_resp_envelope(envelope, status_code, headers) do
    Envelope.add(envelope, :response, %{
      http_status: status_code,
      headers: headers,
      body: ""
    })
  end

  defp request_domain(host) do
    String.replace(host, ~r/.+?(?=\.bbc)/, "", global: false)
  end

  defp next_year_http_date() do
    Utils.Current.date_time()
    |> DateTime.add(@one_year_in_seconds, :second)
    |> Calendar.strftime("%a, %d %b %Y %H:%M:%S GMT")
  end

  defp redirect_url(host, redirect_location) do
    "https://" <>
      host <>
      redirect_location
  end
end
