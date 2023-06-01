defmodule Belfrage.PreflightTransformers.BBCXPlatformSelector do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Envelope

  @allowed_countries ["us", "ca"]

  @impl Transformer
  def call(envelope = %Envelope{request: request, private: %Envelope.Private{production_environment: prod_env}}) do
    platform = if prod_env == "test" &&
         String.ends_with?(request.host, "bbc.com") &&
         Map.get(request.raw_headers, "cookie-ckns_bbccom_beta") == "1" &&
         request.country in @allowed_countries do
      "BBCX"
         else
          "Webcore"
    end

    {:ok, Envelope.add(envelope, :private, %{bbcx_enabled: true, platform: platform})}
  end

 # defp select_platform()
end
