defmodule Belfrage.Transformers.BitesizeLevelsDiscriminator do
  @moduledoc """
  Alters the Platform depending on the environment.
  """
  use Belfrage.Transformers.Transformer

  def call(rest, struct) do
    if to_webcore?() do
      then_do(
        rest,
        Struct.add(struct, :private, %{
          platform: Webcore,
          origin: Application.get_env(:belfrage, :pwa_lambda_function)
        })
      )
    else
      then_do(rest, struct)
    end
  end

  defp to_webcore?() do
    Application.get_env(:belfrage, :production_environment) != "live"
  end
end
