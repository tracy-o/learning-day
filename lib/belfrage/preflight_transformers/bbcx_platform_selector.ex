defmodule Belfrage.PreflightTransformers.BBCXPlatformSelector do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Envelope

  @impl Transformer
  def call(envelope = %Envelope{request: request}) do
    platform =
      cond do
        !Map.has_key?(request.raw_headers, "cookie_ckns_bbccom_beta") -> "Webcore"
        true -> select_platform(envelope.request)
      end

    {:ok, Envelope.add(envelope, :private, %{platform: platform})}
  end

  defp select_platform(%{raw_headers: %{"cookie_ckns_bbccom_beta" => nil}}), do: "Webcore"
  defp select_platform(%{host: "www.bbc.com", country: "us"}), do: "BBCX"
  defp select_platform(%{host: "www.bbc.com", country: "ca"}), do: "BBCX"
  defp select_platform(_), do: "Webcore"
end
