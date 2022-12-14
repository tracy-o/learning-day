defmodule Belfrage.RequestTransformers.WeatherLanguageCookie do
  use Belfrage.Transformer

  @redirect_languages ["en", "cy", "ga", "gd"]

  def call(rest, struct) do
    language = struct.request.path_params["language"]

    if language in @redirect_languages do
      {
        :redirect,
        Struct.add(struct, :response, %{
          http_status: 301,
          headers: %{
            "location" => redirect_url(struct.request),
            "set-cookie" =>
              "ckps_language=#{language}; expires=#{next_year_http_date()}; path=/; domain=#{struct.request.subdomain}",
            "cache-control" => "public, stale-if-error=90, stale-while-revalidate=30, max-age=60"
          },
          body: "Redirecting"
        })
      }
    else
      then_do(rest, struct)
    end
  end

  def next_year_http_date(date \\ DateTime.now("Etc/UTC")) do
    {:ok, current} = date

    %{current | year: current.year + 1}
    |> Calendar.strftime("%a, %d %b %Y %H:%M:%S GMT")
  end

  defp redirect_url(request) do
    to_string(request.scheme) <>
      "://" <>
      request.host <>
      "/weather" <>
      Belfrage.Helpers.QueryParams.encode(request.query_params)
  end
end
