defmodule Belfrage.PreflightTransformers.BBCXPlatformSelector do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Envelope

  @allowed_countries ["us", "ca"]

  @impl Transformer
  def call(envelope = %Envelope{request: request, private: %Envelope.Private{production_environment: prod_env}}) do
    platform =
      cond do
        prod_env == "live" -> "Webcore"
        !Map.has_key?(request.raw_headers, "cookie-ckns_bbccom_beta") -> "Webcore"
        true -> select_platform(request)
      end

    {:ok, Envelope.add(envelope, :private, %{bbcx_enabled: true, platform: platform})}
  end

  defp select_platform(%{raw_headers: %{"cookie-ckns_bbccom_beta" => ""}}), do: "Webcore"
  defp select_platform(%{host: "www.bbc.com", country: country}) when country in @allowed_countries, do: "BBCX"
  defp select_platform(_), do: "Webcore"
end
