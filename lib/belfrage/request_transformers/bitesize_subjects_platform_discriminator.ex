defmodule Belfrage.RequestTransformers.BitesizeSubjectsPlatformDiscriminator do
  @moduledoc """
  Alters the Platform and Origin for a subset of Bitesize Subjects IDs that need to be served by Webcore.
  """
  use Belfrage.Behaviours.Transformer

  @webcore_test_ids [
    "zxtnvcw",
    "zmpfb9q",
    "zphybqt",
    "zhtf3j6",
    "z7mtsbk",
    "zvsc96f",
    "z8yrwmn",
    "zjcdxnb",
    "znwqtfr",
    "zmj2n39",
    "zdmtsbk"
  ]

  @webcore_live_ids [
    "zxtnvcw",
    "zmpfb9q",
    "zphybqt",
    "zhtf3j6",
    "z7mtsbk",
    "zvsc96f",
    "z8yrwmn",
    "zjcdxnb",
    "znwqtfr",
    "zmj2n39"
  ]

  @impl Transformer
  def call(struct = %Struct{request: %Struct.Request{path_params: %{"id" => id}}}) do
    {:ok, maybe_update_origin(id, struct)}
  end

  def call(struct), do: {:ok, struct}

  defp is_webcore_id(id) do
    application_env = Application.get_env(:belfrage, :production_environment)

    if application_env === "live" do
      id in @webcore_live_ids
    else
      id in @webcore_test_ids
    end
  end

  defp maybe_update_origin(id, struct) do
    if is_webcore_id(id) do
      Struct.add(struct, :private, %{
        platform: Webcore,
        origin: Application.get_env(:belfrage, :pwa_lambda_function)
      })
    else
      struct
    end
  end
end
