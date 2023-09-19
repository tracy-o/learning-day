defmodule Belfrage.PreflightTransformers.BitesizeGuidesPlatformSelector do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Behaviours.PreflightService

  @exam_spec_ids [
    "z2synbk",
    "zp49cwx"
  ]

  @scottish_level_ids ["zy4qn39", "zvk2fg8", "z8hhvcw", "zdpp34j", "zp3d7ty", "z6gw2hv", "zqq4wxs", "zkdqxnb"]

  @service "BitesizeGuidesData"

  @impl Transformer
  def call(envelope) do
    case PreflightService.call(envelope, @service) do
      {:ok, envelope = %Envelope{private: %Envelope.Private{preflight_metadata: metadata}}} ->
        guides_data = Map.get(metadata, @service)
        {:ok, Envelope.add(envelope, :private, %{platform: get_platform_by_data(guides_data)})}

      {:error, envelope, :preflight_data_not_found} ->
        {:error, envelope, 404}

      {:error, envelope, :preflight_data_error} ->
        {:error, envelope, 500}
    end
  end

  defp get_platform_by_data(guides_data) do
    if guides_data[:exam_specification] in @exam_spec_ids || guides_data[:level] in @scottish_level_ids do
      "Webcore"
    else
      "MorphRouter"
    end
  end
end
