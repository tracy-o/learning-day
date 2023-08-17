defmodule Belfrage.PreflightTransformers.BitesizeArticlesPlatformSelector do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Behaviours.PreflightService

  @webcore_ids [
    "z6x992p",
    "zj8yydm",
    "zgd682p"
  ]

  @service "BitesizeArticlesData"

  @impl Transformer
  def call(envelope = %Envelope{request: request}) do
    if webcore_id?(request.path_params["id"]) do
      {:ok, Envelope.add(envelope, :private, %{platform: "Webcore"})}
    else
      case PreflightService.call(envelope, @service) do
        {:ok, envelope = %Envelope{private: %Envelope.Private{preflight_metadata: metadata}}} ->
          articles_data = Map.get(metadata, @service)
          {:ok, Envelope.add(envelope, :private, %{platform: get_platform_by_data(articles_data)})}

        {:error, _envelope, :preflight_data_not_found} ->
          {:error, envelope, 404}

        {:error, _envelope, :preflight_data_error} ->
          {:error, envelope, 500}
      end
    end
  end

  defp webcore_id?(id) do
    id in @webcore_ids
  end

  defp get_platform_by_data(articles_data) do
    if articles_data[:phase] == %{} do
      "Webcore"
    else
      "MorphRouter"
    end
  end
end
