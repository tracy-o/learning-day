defmodule Belfrage.Transformers.BitesizeLevelsPlatformDiscriminator do
  @moduledoc """
  Alters the Platform and Origin for a subset of Bitesize level IDs that need to be served by Webcore.
  """
  use Belfrage.Transformers.Transformer

  @webcore_test_ids [
    "zr48q6f",
    "z3g4d2p"
  ]

  @webcore_live_ids []

  def call(rest, struct = %Struct{request: %Struct.Request{path_params: %{"id" => id}}}) do
    then_do(rest, maybe_update_origin(id, struct))
  end

  def call(_rest, struct), do: then_do([], struct)

  defp is_webcore_id(id) do
   Application.get_env(:belfrage, :production_environment) != "live" and id in @webcore_test_ids
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
