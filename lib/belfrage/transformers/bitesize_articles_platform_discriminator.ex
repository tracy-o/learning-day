defmodule Belfrage.Transformers.BitesizeArticlesPlatformDiscriminator do
  @moduledoc """
  Alters the Platform and Origin for a subset of Bitesize Articles IDs that need to be served by Webcore.
  """
  use Belfrage.Transformers.Transformer

  @webcore_test_ids [
    "zm8fhbk",
    "zjykkmn",
    "zj8yydm"
  ]

  @webcore_live_ids []

  def call(_rest, struct = %Struct{request: %Struct.Request{path_params: %{"id" => id}}})
      when id in @webcore_test_ids or @webcore_live_ids do
    then(
      ["Personalisation", "LambdaOriginAlias", "PlatformKillSwitch", "CircuitBreaker", "Language"],
      Struct.add(struct, :private, %{
        platform: Webcore,
        origin: Application.get_env(:belfrage, :pwa_lambda_function)
      })
    )
  end

  def call(_rest, struct), do: then(["CircuitBreaker"], struct)
end
