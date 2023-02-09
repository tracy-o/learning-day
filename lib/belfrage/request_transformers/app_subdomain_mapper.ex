defmodule Belfrage.RequestTransformers.AppSubdomainMapper do
  use Belfrage.Behaviours.Transformer

  # This transformer uses the request subdomain to decide which apps endpoint to
  # send a request to.
  #
  # It also sets the circuit_breaker_error_threshold for each endpoint. These
  # values are purposely high because we won't be falling back for these routes
  # so tripping the circuit breaker would mean returning 500s. Also the content
  # we fetch is stored in S3 so we would only anticipate a high error rate if
  # AWS services became unavailable or were misconfigured.

  # the full host name for these subdomains are:
  # - news-app-classic.test.api.bbci.co.uk
  # - news-app-global-classic.test.api.bbci.co.uk
  # - news-app-ws-classic.test.api.bbci.co.uk

  @impl Transformer
  def call(envelope) do
    case envelope.request.subdomain do
      "news-app-classic" ->
        {:ok, change_endpoint(envelope, "AppsTrevor", :trevor_endpoint, 15_000)}

      "news-app-global-classic" ->
        {:ok, change_endpoint(envelope, "AppsWalter", :walter_endpoint, 8_000)}

      "news-app-ws-classic" ->
        {:ok, change_endpoint(envelope, "AppsPhilippa", :philippa_endpoint, 1_500)}

      _ ->
        {:stop, Envelope.put_status(envelope, 400)}
    end
  end

  defp change_endpoint(envelope, platform, endpoint, threshold) do
    Envelope.add(envelope, :private, %{
      circuit_breaker_error_threshold: threshold,
      origin: Application.get_env(:belfrage, endpoint),
      platform: platform
    })
  end
end
