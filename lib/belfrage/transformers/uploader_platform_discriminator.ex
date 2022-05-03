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
    "u27337389",
    "u65192207",
    "u80306832",
    "u83240760",
    "u88700662",
    "u19839187",
    "u22424925",
    "u104582784",
    "u107788679",
    "u107790797",
    "u23123288",
    "u66493150",
    "u72009131",
    "u51377337",
    "u39697902",
    "u65290961",
    "u39873202",
    "u19819112",
    "u66056565",
    "u75060290",
    "u109852224",
    "u96629812",
    "u44012869",
    "u102772985",
    "u16896881",
    "u17667574",
    "u109593113"
  ]

  defp is_webcore_id(id) do
    id in @webcore_live_campaign_ids
  end

  defp update_platform_and_origin(id, struct) do
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
    then_do(rest, update_platform_and_origin(id, struct))
  end

  def call(_rest, struct), do: then_do([], struct)
end
