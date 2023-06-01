defmodule Belfrage.PreflightTransformers.BBCXPlatformSelector do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Envelope

  @allowed_countries ["us", "ca"]

  @impl Transformer
  def call(envelope = %Envelope{}) do
    {:ok, Envelope.add(envelope, :private, %{bbcx_enabled: true, platform: select_platform(envelope)})}
  end

  defp select_platform(%Envelope{request: request, private: %Envelope.Private{production_environment: prod_env}}) do
    if prod_env == "test" &&
         String.ends_with?(request.host, "bbc.com") &&
         Map.get(request.raw_headers, "cookie-ckns_bbccom_beta") == "1" &&
         request.country in @allowed_countries do
      "BBCX"
    else
      "Webcore"
    end
  end
end
