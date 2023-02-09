defmodule Belfrage.RequestTransformers.PlatformKillSwitch do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Envelope.Private

  @dial Application.compile_env(:belfrage, :dial)

  @platform_map %{
    "Webcore" => :webcore_kill_switch
  }

  @impl Transformer
  def call(envelope = %Envelope{private: %Private{platform: platform}}) do
    if killswitch_active?(platform) do
      {:stop, Envelope.add(envelope, :response, %{http_status: 500})}
    else
      {:ok, envelope}
    end
  end

  defp killswitch_active?(platform) do
    if dial = @platform_map[platform] do
      @dial.state(dial)
    end
  end
end
