defmodule Belfrage.RequestTransformers.BitesizeLevelsPlatformDiscriminator do
  @moduledoc """
  Alters the Platform and Origin for a subset of Bitesize level IDs that need to be served by Webcore.
  """
  use Belfrage.Behaviours.Transformer

  @valid_year_ids [
    "zjpqqp3",
    "z7s22sg",
    "zmyxxyc",
    "z63tt39",
    "zhgppg8",
    "zncsscw"
  ]

  @webcore_test_ids [
    "zr48q6f",
    "z3g4d2p"
  ]

  @webcore_live_ids []

  @impl Transformer
  def call(struct = %Struct{request: %Struct.Request{path_params: %{"id" => id}}}) do
    {:ok, maybe_update_origin(id, struct)}
  end

  def call(struct = %Struct{request: %Struct.Request{path_params: %{"id" => id, "year_id" => year_id}}}) do
    if year_id in @valid_year_ids do
      {:ok, maybe_update_origin(id, struct)}
    else
      {:ok, struct}
    end
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
        platform: "Webcore",
        origin: Application.get_env(:belfrage, :pwa_lambda_function)
      })
    else
      struct
    end
  end
end
