defmodule Belfrage.RequestTransformers.BitesizeArticlesPlatformDiscriminator do
  @moduledoc """
  Alters the Platform and Origin for a subset of Bitesize Articles IDs that need to be served by Webcore.
  """
  use Belfrage.Behaviours.Transformer

  @webcore_test_ids [
    "zm8fhbk",
    "zjykkmn",
    "zj8yydm",
    "zwdtrwx"
  ]

  @webcore_live_ids [
    "zj8yydm"
  ]

  @impl Transformer
  def call(envelope = %Envelope{request: %Envelope.Request{path_params: %{"id" => id}}}) do
    {:ok, maybe_update_origin(id, envelope)}
  end

  def call(envelope), do: {:ok, envelope}

  defp is_webcore_id(id) do
    application_env = Application.get_env(:belfrage, :production_environment)

    if application_env === "live" do
      id in @webcore_live_ids
    else
      id in @webcore_test_ids
    end
  end

  defp maybe_update_origin(id, envelope) do
    case is_webcore_id(id) do
      true ->
        Envelope.add(envelope, :private, %{
          platform: "Webcore",
          origin: Application.get_env(:belfrage, :pwa_lambda_function)
        })

      _ ->
        envelope
    end
  end
end
