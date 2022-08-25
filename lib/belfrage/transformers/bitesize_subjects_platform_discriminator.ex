defmodule Belfrage.Transformers.BitesizeSubjectsPlatformDiscriminator do
  @moduledoc """
  Alters the Platform and Origin for a subset of Bitesize Subjects IDs that need to be served by Webcore.
  """
  use Belfrage.Transformers.Transformer

  @webcore_test_ids [
    "zbhy4wx",
    "zjxhfg8"
  ]

  @webcore_live_ids []

  def call(rest, struct = %Struct{request: %Struct.Request{path_params: %{"id" => id}}}) do
    then_do(rest, maybe_update_origin(id, struct))
  end

  def call(_rest, struct), do: then_do([], struct)

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
