defmodule Belfrage.Transformers.UploaderPlatformDiscriminator do
  @moduledoc """
  Alters the Platform and Origin for a subset of Uploader Campaign IDs that need to be served by Webcore.
  """
  use Belfrage.Transformers.Transformer

  @webcore_live_campaign_ids [
    "u4033755",
    "u4034047",
    "u4034119",
    "u20687123",
    "u108055402",
    "u101147302",
    "u84541713",
    "u27337389"
  ]

  defp is_webcore_id(id) do
    application_env = Application.get_env(:belfrage, :production_environment)

    if application_env === "live" do
      id in @webcore_live_campaign_ids
    end
  end

  defp maybe_update_platform_and_origin(id, struct) do
    case is_webcore_id(id) do
      true ->
        Struct.add(struct, :private, %{
          platform: Webcore,
          origin: Application.get_env(:belfrage, :pwa_lambda_function)
        })

      _ ->
        struct
    end
  end

  def call(rest, struct = %Struct{request: %Struct.Request{path_params: %{"id" => id}}}) do
    then_do(rest, maybe_update_platform_and_origin(id, struct))
  end

  def call(_rest, struct), do: then_do([], struct)
end
