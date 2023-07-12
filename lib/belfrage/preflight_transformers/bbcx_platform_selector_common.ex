defmodule Belfrage.PreflightTransformers.BBCXPlatformSelectorCommon do
  alias Belfrage.{Envelope, Brands}

  def add_platform_to_envelope(envelope = %Envelope{}, route_platform) do
    {:ok,
     Envelope.add(envelope, :private, %{
       bbcx_enabled: Brands.bbcx_enabled?(),
       platform: select_platform(envelope, route_platform)
     })}
  end

  defp select_platform(
         envelope,
         route_platform
       ) do
    if Brands.is_bbcx?(envelope) do
      "BBCX"
    else
      route_platform
    end
  end
end
