defmodule Belfrage.PreflightTransformers.BitesizeGuidesPlatformSelector do
  use Belfrage.Behaviours.Transformer

  @webcore_test_ids [
    "zw3bfcw",
    "zwsffg8",
    "zcvy6yc",
    "zw7xfcw",
    "z9ppv4j",
    "z8ssbk7",
    "z9vvcwx",
    "z8bb9qt"
  ]

  @webcore_live_ids [
    "z9ppv4j",
    "z8ssbk7",
    "z9vvcwx",
    "z8bb9qt"
  ]

  @impl Transformer
  def call(envelope = %Envelope{request: request}) do
    {:ok, Envelope.add(envelope, :private, %{platform: get_platform(request)})}
  end

  defp webcore_live_id?(id) do
    id in @webcore_live_ids
  end

  defp webcore_test_id?(id) do
    id in @webcore_test_ids
  end

  defp production_environment() do
    Application.get_env(:belfrage, :production_environment)
  end

  defp get_platform(%Envelope.Request{path_params: %{"id" => id}}) do
    cond do
      production_environment() == "live" and webcore_live_id?(id) ->
        "Webcore"

      production_environment() == "test" and webcore_test_id?(id) ->
        "Webcore"

      true ->
        "MorphRouter"
    end
  end

  defp get_platform(_request) do
    "MorphRouter"
  end
end
