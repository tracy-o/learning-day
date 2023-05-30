defmodule Belfrage.PreflightTransformers.BBCXPlatformSelector do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Envelope

  @allowed_countries ["us", "ca"]

  #TODO
  # - add unit tests for the vary header
  # - add end to end tests for the production env. we want bbcx to be only on test

  @impl Transformer
  def call(envelope = %Envelope{request: request}) do
    platform =
      if !Map.has_key?(request.raw_headers, "cookie_ckns_bbccom_beta") do
        "Webcore"
      else
        select_platform(request)
      end

    {:ok, Envelope.add(envelope, :private, %{bbcx_enabled: true, platform: platform})}
  end

  defp select_platform(%{raw_headers: %{"cookie_ckns_bbccom_beta" => ""}}), do: "Webcore"
  defp select_platform(%{host: "www.bbc.com", country: country}) when country in @allowed_countries, do: "BBCX"
  defp select_platform(_), do: "Webcore"
end
