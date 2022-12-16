defmodule Belfrage.RequestTransformers.WeatherLanguageCookie do
  use Belfrage.Transformer

  alias Belfrage.Utils

  @redirect_languages ["en", "cy", "ga", "gd"]
  @one_year_in_seconds 365 * 24 * 3600

  def call(rest, struct) do
    language = struct.request.path_params["language"]
    redirect_location = struct.request.query_params["redirect_location"] || "/weather"

    cond do
      not BelfrageWeb.Validators.matches?(redirect_location, ~r/^[\/]/) ->
        {
          :stop_pipeline,
          Struct.add(struct, :response, %{
            http_status: 404,
            body: ""
          })
        }

      language not in @redirect_languages ->
        {
          :stop_pipeline,
          Struct.add(struct, :response, %{
            http_status: 400,
            body: ""
          })
        }

      true ->
        {
          :redirect,
          Struct.add(struct, :response, %{
            http_status: 301,
            headers: %{
              "location" => redirect_url(struct.request),
              "set-cookie" =>
                "ckps_language=#{language}; expires=#{next_year_http_date()}; path=/; domain=#{request_domain(struct.request.host)}",
              "cache-control" => "public, stale-if-error=90, stale-while-revalidate=30, max-age=60"
            },
            body: ""
          })
        }
    end
  end

  defp request_domain(host) do
    String.replace(host, ~r/.+?(?=\.bbc)/, "", global: false)
  end

  defp next_year_http_date() do
    Utils.Current.date_time()
    |> DateTime.add(@one_year_in_seconds, :second)
    |> Calendar.strftime("%a, %d %b %Y %H:%M:%S GMT")
  end

  defp redirect_url(request) do
    "https://" <>
      request.host <>
      "/weather" <>
      Belfrage.Helpers.QueryParams.encode(request.query_params)
  end
end
