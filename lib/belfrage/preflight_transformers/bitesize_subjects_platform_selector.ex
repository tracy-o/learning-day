defmodule Belfrage.PreflightTransformers.BitesizeSubjectsPlatformSelector do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Behaviours.PreflightService

  @impl Transformer
  def call(envelope = %Envelope{}) do
    case PreflightService.call(envelope, "BitesizeSubjectsData") do
      {:ok, envelope, subject_level} ->
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
