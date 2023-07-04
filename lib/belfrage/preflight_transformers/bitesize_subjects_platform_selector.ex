defmodule Belfrage.PreflightTransformers.BitesizeSubjectsPlatformSelector do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Behaviours.PreflightService

  @impl Transformer
  def call(envelope = %Envelope{}) do
    if envelope.private.production_environment == "live" do
      {:ok, Envelope.add(envelope, :private, %{platform: "MorphRouter"})}
    else
      case PreflightService.call(envelope, "BitesizeSubjectsData") do
        {:ok, subject_level} ->
          {:ok, Envelope.add(envelope, :private, %{platform: get_platform(subject_level)})}

        {:error, :preflight_data_not_found} ->
          {:error, envelope, 404}

        {:error, :preflight_data_error} ->
          {:error, envelope, 500}
      end
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