defmodule Belfrage.PreflightTransformers.ClassicAppsPlatformSelector do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(envelope) do
    case select_platform(envelope.request.subdomain) do
      {:ok, platform} ->
        {:ok, Envelope.add(envelope, :private, %{platform: platform})}

      _ ->
        {:error, envelope, 400}
    end
  end

  defp select_platform("news-app-classic"), do: {:ok, "AppsTrevor"}
  defp select_platform("news-app-global-classic"), do: {:ok, "AppsWalter"}
  defp select_platform("news-app-ws-classic"), do: {:ok, "AppsPhilippa"}
  defp select_platform(_), do: {:error}
end
