defmodule Belfrage.Transformers.BitesizeLevelsDiscriminator do
  @moduledoc """
  Alters the Platform depending on the environment.
  """
  use Belfrage.Transformers.Transformer

  defp maybe_update_origin(struct) do
    application_env = Application.get_env(:belfrage, :production_environment)

    if application_env === "live" do
      Struct.add(struct, :private, %{
        platform: Webcore,
        origin: Application.get_env(:belfrage, :pwa_lambda_function)
      })
    else
      struct
    end
  end

  def call(rest, struct) do
    then_do(rest, maybe_update_origin(struct))
  end

  def call(_rest, struct), do: then_do([], struct)
end
