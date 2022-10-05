defmodule Belfrage.Transformers.LivePagePlatformDiscriminator do
  use Belfrage.Transformers.Transformer

  def call(rest, struct) do
    application_env = Application.get_env(:belfrage, :production_environment)

    # currently we don't want to show webcore pages in live environment
    if tipo_id?(struct) && application_env != "live" do
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

  defp tipo_id?(struct) do
    String.match?(struct.request.path, ~r/\/(c[abcdefghjklmnpqrstuvwxyz0-9]{10,}t)$/)
  end
end