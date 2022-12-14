defmodule Belfrage.RequestTransformers.WeatherLanguageCookie do
  use Belfrage.Transformer

  def call(rest, struct) do
    if language_path?(struct.request.path) do
      "/weather/language/" <> lang = struct.request.path

      {
        :redirect,
        Struct.add(struct, :response, %{
          http_status: 301,
          headers: %{
            "location" => redirect_url(struct.request),
            "set-cookie" =>
              "ckps_language=#{lang}; expires=#{next_year_http_date()}; path=/; domain=#{struct.request.subdomain}",
            "cache-control" => "public, stale-if-error=90, stale-while-revalidate=30, max-age=60"
          },
          body: "Redirecting"
        })
      }
    else
      then_do(rest, struct)
    end
  end

  defp language_path?(path), do: path =~ ~r/^\/weather\/language\/(en|cy|ga|gd)$/

  @spec valid_domain?(binary) :: boolean
  def valid_domain?(host) do
    [_subdomain, top_level_domain] = String.split(host, ".bbc")
    ("bbc" <> top_level_domain) in ["bbc.co.uk", "bbc.com"]
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
