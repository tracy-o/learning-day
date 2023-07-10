defmodule Belfrage.PreflightTransformers.SportLivePlatformSelector do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(envelope = %Envelope{request: request}) do
    {:ok, Envelope.add(envelope, :private, %{platform: get_platform(request)})}
  end

  defp get_platform(%Envelope.Request{path_params: %{"asset_id" => id}}) do
    if BelfrageWeb.Validators.is_tipo_id?(id) do
      "Webcore"
    else
      "MozartSport"
    end
  end
end
