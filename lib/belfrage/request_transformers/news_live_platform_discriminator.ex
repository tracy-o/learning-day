defmodule Belfrage.RequestTransformers.NewsLivePlatformDiscriminator do
  use Belfrage.Behaviours.Transformer

  def call(envelope) do
    application_env = Application.get_env(:belfrage, :production_environment)

    # currently we don't want to show webcore pages in live environment
    if tipo_id?(envelope) && application_env != "live" do
      {
        :ok,
        Envelope.add(envelope, :private, %{
          platform: "Webcore",
          origin: Application.get_env(:belfrage, :pwa_lambda_function)
        }),
        {:replace, ["LambdaOriginAlias", "CircuitBreaker"]}
      }
    else
      {:ok, envelope}
    end
  end

  defp tipo_id?(envelope) do
    String.match?(envelope.request.path_params["asset_id"], ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}t$/)
  end
end
