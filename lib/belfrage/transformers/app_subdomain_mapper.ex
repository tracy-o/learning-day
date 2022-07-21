defmodule Belfrage.Transformers.AppSubdomainMapper do
  use Belfrage.Transformers.Transformer

  alias Belfrage.Struct

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

  def call(rest, struct) do
    case struct.request.subdomain do
      "news-app-classic" ->
        then_do(rest, change_endpoint(struct, :trevor_endpoint, 15_000))

      "news-app-global-classic" ->
        then_do(rest, change_endpoint(struct, :walter_endpoint, 8_000))

      "news-app-ws-classic" ->
        then_do(rest, change_endpoint(struct, :philippa_endpoint, 1_500))

      _ ->
        {:stop_pipeline, Struct.put_status(struct, 400)}
    end
  end

  defp change_endpoint(struct, endpoint, threshold) do
    Struct.add(struct, :private, %{
      origin: Application.get_env(:belfrage, endpoint),
      circuit_breaker_error_threshold: threshold
    })
  end
end
