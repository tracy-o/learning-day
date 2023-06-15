defmodule Belfrage.PreflightTransformers.BBCXPlatformSelector do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.{Brands, Envelope}

  @impl Transformer
  def call(envelope = %Envelope{}) do
    {:ok,
     Envelope.add(envelope, :private, %{
       bbcx_enabled: bbcx_enabled?(envelope),
       platform: select_platform(envelope)
     })}
  end

  defp bbcx_enabled?(%Envelope{private: %Envelope.Private{production_environment: prod_env}}) do
    prod_env == "test"
  end

  defp select_platform(envelope) do
    if Brands.is_bbcx?(envelope) do
      "BBCX"
    else
      "Webcore"
    end
  end
end
