defmodule Belfrage.Transformers.BitesizeLevelsDiscriminator do
  @moduledoc """
  Alters the Platform and Origin for a subset of Bitesize Levels IDs that need to be served by Webcore.
  """
  use Belfrage.Transformers.Transformer

  @webcore_test_ids [
      z98jmp3,
      z8w76sg,
      zr48q6f,
      zjmj92p,
      z4kw2hv,
      z3hbg7h,
      z6gw2hv, 
      z8w76sg,
      z4js6v4
  ]

  @webcore_live_ids []

  defp is_webcore_id(id) do
    application_env = Application.get_env(:belfrage, :production_environment)

    if application_env === "live" do
      id in @webcore_live_ids
    else
      id in @webcore_test_ids
    end
  end

  defp maybe_update_origin(id, struct) do
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
    then_do(rest, maybe_update_origin(id, struct))
  end

  def call(_rest, struct), do: then_do([], struct)
end
