defmodule Belfrage.PreflightTransformers.BitesizeSubjectsPlatformSelector do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.{Behaviours.PreflightService, Envelope, Envelope.Private}

  @service "BitesizeSubjectsData"

  @impl Transformer
  def call(envelope = %Envelope{}) do
    case PreflightService.call(envelope, @service) do
      {:ok, envelope = %Envelope{private: %Private{preflight_metadata: metadata}}} ->
        subject_level = Map.get(metadata, @service)
        {:ok, Envelope.add(envelope, :private, %{platform: get_platform(subject_level)})}

      {:error, envelope, :preflight_data_not_found} ->
        {:error, envelope, 404}

      {:error, envelope, :preflight_data_error} ->
        {:error, envelope, 500}
    end
  end

  defp get_platform(subject_level) do
    if subject_level in ["Primary", ""] do
      "Webcore"
    else
      "MorphRouter"
    end
  end
end
