defmodule Belfrage.PreflightTransformers.BBCXPlatformSelector do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Envelope

  @dial Application.compile_env(:belfrage, :dial)

  @allowed_countries ["us", "ca"]

  @impl Transformer
  def call(envelope = %Envelope{}) do
    {:ok,
     Envelope.add(envelope, :private, %{bbcx_enabled: bbcx_enabled?(envelope), platform: select_platform(envelope)})}
  end

  defp bbcx_enabled?(%Envelope{private: %Envelope.Private{production_environment: prod_env}}) do
    if prod_env == "test" do
      true
    else
      false
    end
  end

  defp select_platform(%Envelope{request: request, private: %Envelope.Private{production_environment: prod_env}}) do
    if prod_env == "test" &&
         bbcx_enabled?() &&
         String.ends_with?(request.host, "bbc.com") &&
         Map.get(request.raw_headers, "cookie-ckns_bbccom_beta") == "1" &&
         request.country in @allowed_countries do
      "BBCX"
    else
      "Webcore"
    end
  end

  defp bbcx_enabled? do
    @dial.state(:bbcx_enabled) == true
  end
end
