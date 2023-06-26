defmodule Belfrage.PreflightTransformers.BBCXPlatformSelectorCommon do
  alias Belfrage.Envelope

  @dial Application.compile_env(:belfrage, :dial)

  @allowed_countries ["us", "ca"]

  def add_platform_to_envelope(envelope = %Envelope{}, route_platform) do
    {:ok,
     Envelope.add(envelope, :private, %{
       bbcx_enabled: bbcx_enabled?(envelope),
       platform: select_platform(envelope, route_platform)
     })}
  end

  defp bbcx_enabled?(%Envelope{private: %Envelope.Private{production_environment: prod_env}}) do
    prod_env == "test"
  end

  defp select_platform(
         %Envelope{
           request: request,
           private: %Envelope.Private{production_environment: prod_env}
         },
         route_platform
       ) do
    if prod_env == "test" &&
         @dial.state(:bbcx_enabled) == true &&
         String.ends_with?(request.host, "bbc.com") &&
         Map.get(request.raw_headers, "cookie-ckns_bbccom_beta") == "1" &&
         request.country in @allowed_countries do
      "BBCX"
    else
      route_platform
    end
  end
end
